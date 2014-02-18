class Storys::Story
  attr_reader :package
  attr_reader :path, :nsf

  def initialize(package, path)
    @package = package
    @path = path
    @nsf = Nsf::Document.from_html(File.read(@path))
  end

  def path_hash
    Digest::SHA256.hexdigest(path.to_s)[0..16]
  end

  def url
    package.pathname_to_url(path, package.package_path)
  end

  def title
    title = nsf.title 
    title = path.basename.to_s.chomp(path.extname.to_s) if title == ""

    directory_path = path.relative_path_from(package.root_path).dirname.to_s

    title = "#{directory_path}/#{title}" unless directory_path == "" || directory_path == "."
    title = title.gsub("/", " / ")

    title
  end

  def self.from_hash(package, data)
    Storys::Story.new(package, package.url_to_pathname(Addressable::URI.parse(data["url"])))
  end

  def to_hash
    {
      "url" => url,
      "wordCount" => nsf.to_nsf.split(/\s+/).length,
      "title" => title,
      "publishedOn" => path.mtime.to_i,
      "key" => path_hash
    }
  end
end
