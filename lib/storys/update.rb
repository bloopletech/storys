class Storys::Update
  attr_reader :storys
  attr_accessor :stories

  def initialize(storys)
    @storys = storys

    @files = storys.root_path.descendant_files.reject { |p| p.basename.to_s[0..0] == '.' }
    @stories = []
    #load_data
    process
    save_data
  end

  def load_data
    self.stories = (Storys::Storys.load_json(storys.storys_path + "data.json") || []).map { |b| Storys::Story.from_hash(storys, b) }
  end

  def save_data
    puts "\nWriting out JSON file"
    Storys::Storys.save_json(storys.storys_path + "data.json", stories.map { |b| b.to_hash })
  end

  def process
    @files.each_with_index do |f, i|
      $stdout.write "\rProcessing #{i + 1} of #{@files.length} (#{(((i + 1) / @files.length.to_f) * 100.0).round}%)"
      $stdout.flush

      created f
    end
    #handle deleted first
    #@files.each do |f|
    #  puts "f: #{f.inspect}"
    #  story = stories.find { |b| b.path == f }
    #  if story
    #    updated(story)
    #  else
    #    created(f)
    #  end
    #end
  end

  def deleted
    #
  end

  def created(f)
    story = Storys::Story.new(storys, f)
    stories << story
  end

  def updated(story)
    puts "updating: #{story.inspect}"
    #
  end
end
