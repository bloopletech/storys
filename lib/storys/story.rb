class Storys::Story
  attr_reader :storys
  attr_reader :path, :nsf

  def initialize(storys, path)
    @storys = storys
    @path = path
    @nsf = Nsf::Document.from_html(File.read(@path))
  end

  def path_hash
    Digest::SHA256.hexdigest(path.to_s)[0..16]
  end

  def url
    storys.pathname_to_url(path, storys.storys_path)
  end

  def title
    nsf.title
  end

  def self.from_hash(storys, data)
    Storys::Story.new(storys, storys.url_to_pathname(Addressable::URI.parse(data["url"])))
  end

  def to_hash
    {
      "url" => url,
      "wordCount" => 0,
      "title" => title,
      "publishedOn" => path.mtime.to_i,
      "key" => path_hash
    }
  end
end
