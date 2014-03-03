class Storys::Story
  attr_reader :package
  attr_reader :path

  def initialize(package, path)
    @package = package
    @path = path
  end

  #It is assumed that the HTML document is a valid HTML expression of an NSF document
  def html
    @html ||= File.read(@path)
  end

  def path_hash
    Digest::SHA256.hexdigest(path.to_s)[0..16]
  end

  def url
    package.pathname_to_url(path, package.app_path)
  end

  def title
    title = title_from_html
    title = path.basename.to_s.chomp(path.extname.to_s) if title == ""

    directory_path = path.relative_path_from(package.path).dirname.to_s

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
      "wordCount" => word_count_from_html,
      "title" => title,
      "publishedOn" => path.mtime.to_i,
      "key" => path_hash
    }
  end

  def update_manifest
    manifest_path = package.pathname_to_url(package.app_path + "manifest", path.dirname)
    new_html = html.sub(/<html.*?>/, "<html manifest=\"#{manifest_path}\">")
    File.open(path, "w") { |f| f << new_html }
  end

  private

  def title_from_html
    html =~ /<title>(.*?)<\/title>/m
    $1 ? CGI::unescapeHTML($1) : ""
  end

  def word_count_from_html
    html =~ /<body.*?>(.*?)<\/body>/m
    body = CGI::unescapeHTML($1.gsub(/<\/?(p|b|i|h[1234567]).*?>/m, " "))
    (title + " " + (body ? body : "")).split(/\s+/).length
  end
end
