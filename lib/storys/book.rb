class Storys::Book
  attr_reader :storys
  attr_accessor :path

  def initialize(storys)
    @storys = storys
  end

  def path_hash
    Digest::SHA256.hexdigest(path.to_s)[0..16]
  end

  def url
    storys.pathname_to_url(path, storys.storys_path)
  end

  def page_paths
    path.children.select { |p| p.image? && !p.hidden? }.sort_by { |p| Naturally.normalize(p.basename) }
  end

  def page_urls
    page_paths.map { |p| storys.pathname_to_url(p, path) }
  end

  def title
    path.basename.to_s
  end

  def thumbnail_path
    storys.storys_path + "img/thumbnails/" + "#{path_hash}.jpg"
  end

  def thumbnail_url
    storys.pathname_to_url(thumbnail_path, storys.storys_path)
  end

  PREVIEW_WIDTH = 211
  PREVIEW_HEIGHT = 332

  PREVIEW_SMALL_WIDTH = 98
  PREVIEW_SMALL_HEIGHT = 154

  def generate_thumbnail
    return if thumbnail_path.exist?

    img = Magick::Image.read(page_paths.first).first

    p_width = PREVIEW_WIDTH
    p_height = PREVIEW_HEIGHT

    if (img.columns > img.rows) && img.columns > p_width && img.rows > p_height #if it's landscape-oriented
      img.crop!(Magick::EastGravity, img.rows / (p_height / p_width.to_f), img.rows) #Resize it so the right-most part of the image is shown
    end

    img.change_geometry!("#{p_width}>") { |cols, rows, _img| _img.resize!(cols, rows) }

    img.page = Magick::Rectangle.new(img.columns, img.rows, 0, 0)
    img = img.extent(p_width, p_height, 0, 0)
    img.excerpt!(0, 0, p_width, p_height)

    img.write(thumbnail_path)
  rescue Exception => e
    puts "There was an error generating thumbnail: #{e.inspect}"
  end

  def self.from_hash(storys, data)
    book = Storys::Book.new(storys)
    book.path = storys.url_to_pathname(Addressable::URI.parse(data["url"]))
    book
  end

  def to_hash
    {
      "url" => url,
      "pageUrls" => page_urls,
      "pages" => page_urls.length,
      "title" => title,
      "publishedOn" => path.mtime.to_i,
      "thumbnailUrl" => thumbnail_url,
      "key" => path_hash
    }
  end
end
