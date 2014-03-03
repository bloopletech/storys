require "spec_helper"

describe Storys::Story do
  def html_factory(title = "Test", body = "<p>This is an example sentence with eight words.</p>")
    <<-EOF
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    #{"<title>#{title}</title>" unless title.nil?}
  </head>
  #{"<body>\n    #{body}\n  </body>" unless body.nil?}
</html>
EOF
  end

  context "#title" do
    context "basic html" do
      before { Storys::Story.any_instance.stub(:html).and_return { html_factory } }
      context "file in root directory" do
        let!(:story) { build :story }
        it { expect(story.title).to eq("Test") }
      end
      context "file in sub directory" do
        let!(:story) { build :story, path: Pathname.new("a/b.html") }
        it { expect(story.title).to eq("a / Test") }
      end
      context "file in a deeply nested directory" do
        let!(:story) { build :story, path: Pathname.new("alpha/beta/gamma/delta/epsilon.html") }
        it { expect(story.title).to eq("alpha / beta / gamma / delta / Test") }
      end
    end

    context "no title in html" do
      before { Storys::Story.any_instance.stub(:html).and_return { html_factory("") } }
      context "file in root directory" do
        let!(:story) { build :story, path: Pathname.new("zetta.html") }
        it { expect(story.title).to eq("zetta") }
      end
      context "file in sub directory" do
        let!(:story) { build :story, path: Pathname.new("a/b.html") }
        it { expect(story.title).to eq("a / b") }
      end
      context "file in a deeply nested directory" do
        let!(:story) { build :story, path: Pathname.new("alpha/beta/gamma/delta/epsilon.html") }
        it { expect(story.title).to eq("alpha / beta / gamma / delta / epsilon") }
      end
    end
  end

  context "#title_from_html" do
    let!(:story) { build :story }
    context "is present" do
      before { story.stub(:html).and_return { html_factory } }
      it { expect(story.title_from_html).to eq("Test") }
    end
    context "is present and complex" do
      before { story.stub(:html).and_return { html_factory("A Complex %^%*&^*% tITLE\nWith embedded newline") } }
      it { expect(story.title_from_html).to eq("A Complex %^%*&^*% tITLE With embedded newline") }
    end
    context "is present and has extra spaces" do
      before { story.stub(:html).and_return { html_factory("SPAAAAAACE!  And some more ") } }
      it { expect(story.title_from_html).to eq("SPAAAAAACE! And some more") }
    end
    context "is empty" do
      before { story.stub(:html).and_return { html_factory("") } }
      it { expect(story.title_from_html).to eq("") }
    end
    context "is missing" do
      before { story.stub(:html).and_return { html_factory(nil) } }
      it { expect(story.title_from_html).to eq("") }
    end
  end

  context "#word_count_from_html" do
    let!(:story) { build :story }
    context "has some words" do
      before { story.stub(:html).and_return { html_factory } }
      it { expect(story.word_count_from_html).to eq(9) }
    end
    context "has words but no title" do
      before { story.stub(:html).and_return { html_factory(nil) } }
      it { expect(story.word_count_from_html).to eq(9) }
    end
    context "is empty" do
      before { story.stub(:html).and_return { html_factory("Test", "") } }
      it { expect(story.word_count_from_html).to eq(1) }
    end
  end
end
