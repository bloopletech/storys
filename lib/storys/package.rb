class Storys::Package
  attr_reader :path
  attr_reader :app_path

  def initialize(path)
    raise "path must be an instance of Pathname" unless path.is_a?(Pathname)

    @path = path
    @app_path = path + ".storys/"
  end

  def pathname_to_url(path, relative_from)
    URI.escape(path.relative_path_from(relative_from).cleanpath.to_s)
  end

  #FIXME: Doesn't work!
  def url_to_pathname(url)
    path = Addressable::URI.unencode_component(url.normalized_path)
    path.gsub!(/^\//, "") #Make relative, if we allow mounting at a different root URL this will need to remove the root instead of just '/'
    root_url_path + path
  end

  def update
    app_path.mkdir unless File.exists?(app_path)
    Storys::Update.new(self)
    update_app
  end

  def update_app
    dev = ENV["STORYS_ENV"] == "development"

    app_children_paths.each do |file|
      storys_file = app_path + file.basename
      FileUtils.rm_rf(storys_file, :verbose => dev)
    end

    if dev
      app_children_paths.each do |file|
        storys_file = app_path + file.basename
        FileUtils.ln_sf(file, storys_file, :verbose => dev)
      end
    else
      FileUtils.cp_r(Storys::Package.gem_path + "app/.", app_path, :verbose => dev)
    end

    save_manifest

    FileUtils.chmod_R(0755, app_path, :verbose => dev)
  end

  def save_manifest
    File.open(app_path + "manifest", "w") do |f|
      f << <<-EOFSM
CACHE MANIFEST
# Timestamp #{Time.now.to_i}
CACHE:
css/lib/bootstrap.css
css/app.css
css/views.index.css
css/views.show.css
js/lib/jquery-2.0.3.js
js/lib/bootstrap.js
js/lib/underscore.js
js/lib/jquery.browser.js
js/jquery.twoup.js
js/framework.js
js/controllers.index.js
js/controllers.show.js
js/app.js
img/icons/page_white_stack.png
fonts/lib/glyphicons-halflings-regular.eot
fonts/lib/glyphicons-halflings-regular.svg
fonts/lib/glyphicons-halflings-regular.ttf
fonts/lib/glyphicons-halflings-regular.woff
data.json
EOFSM
    end
  end

  def self.gem_path
    Pathname.new(__FILE__).dirname.parent.parent
  end

  def self.load_json(path)
    if File.exists?(path)
      JSON.parse(File.read(path))
    else
      nil
    end
  end

  def self.save_json(path, data)
    File.open(path, "w") { |f| f << data.to_json }
  end

  private
  def app_children_paths
    gem_app_path = Storys::Package.gem_path + "app/"
    gem_app_path.children.reject { |f| f.basename.to_s == "img"} #TODO: Deal with this directory properly
  end
end
