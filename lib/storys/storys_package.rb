class Storys::Storys
  def initialize(root_path)
    raise "root_path must be an instance of Pathname" unless root_path.is_a?(Pathname)

    @root_path = root_path
    @storys_path = root_path + ".storys/"
  end

  def update
    storys_path.mkdir unless File.exists?(storys_path)
    update_app
    Storys::Update.new(self)
  end

  def update_app
    dev = ENV["STORYS_ENV"] == "development"

    app_children_paths.each do |file|
      storys_file = storys_path + file.basename
      FileUtils.rm_rf(storys_file, :verbose => dev)
    end

    if dev
      app_children_paths.each do |file|
        storys_file = storys_path + file.basename
        FileUtils.ln_sf(file, storys_file, :verbose => dev)
      end
    else
      FileUtils.cp_r(Storys::Storys.gem_path + "app/.", storys_path, :verbose => dev)
    end

    FileUtils.chmod_R(0755, storys_path, :verbose => dev)
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
    app_path = Storys::Storys.gem_path + "app/"
    app_path.children.reject { |f| f.basename.to_s == "img"} #TODO: Deal with this directory properly
  end
end
