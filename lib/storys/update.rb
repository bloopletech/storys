class Storys::Update
  attr_reader :package
  attr_accessor :stories

  def initialize(package)
    @package = package

    @files = package.path.descendant_files.reject { |p| p.basename.to_s[0..0] == '.' }
    @stories = []
    #load_data
    convert_files
    process
    save_data
    puts "\nDone!"
  end

  def load_data
    self.stories = (Storys::Package.load_json(package.app_path + "data.json") || []).map { |b| Storys::Story.from_hash(package, b) }
  end

  def save_data
    puts "\nWriting out JSON file"
    stories_hashes = []
    stories.each_with_index do |s, i|
      $stdout.write "\rProcessing #{i + 1} of #{stories.length} (#{(((i + 1) / stories.length.to_f) * 100.0).round}%)"
      $stdout.flush

      stories_hashes << s.to_hash
    end
    Storys::Package.save_json(package.app_path + "data.json", stories_hashes)
  end

  def process
    puts "\nLoading files"
    each_file do |f|
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

  def created(path)
    story = Storys::Story.new(package, path)
    story.update_manifest
    stories << story
  end

  def updated(story)
    puts "updating: #{story.inspect}"
    #
  end

  def convert_files
    puts "\nConverting files to NSF format..."
    each_file do |f|
      convert_file f
    end
  end

  def convert_file(path)
    doc = Nsf::Document.from_html(path.read)
    new_path = path.update_ext(".html")
    new_path.write(doc.to_html, preserve_mtime: true)
  end

  def each_file
    @files.each_with_index do |f, i|
      $stdout.write "\rProcessing #{i + 1} of #{@files.length} (#{(((i + 1) / @files.length.to_f) * 100.0).round}%)"
      $stdout.flush

      yield f
    end
  end
end
