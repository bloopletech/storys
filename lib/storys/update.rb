class Storys::Update
  attr_reader :storys
  attr_accessor :books

  def initialize(storys)
    @storys = storys

    @directories = storys.root_path.descendant_directories.reject { |p| p.basename.to_s[0..0] == '.' }
    load_data
    process
    save_data
  end

  def load_data
    self.books = (Storys::Storys.load_json(storys.storys_path + "data.json") || []).map { |b| Storys::Book.from_hash(storys, b) }
  end

  def save_data
    Storys::Storys.save_json(storys.storys_path + "data.json", books.map { |b| b.to_hash })
  end

  def process
    #handle deleted first
    @directories.each do |d|
      puts "d: #{d.inspect}"
      book = books.find { |b| b.path == d }
      if book
        updated(book)
      else
        created(d)
      end
    end
  end

  def deleted
    #
  end

  def created(directory)
    puts "creating: #{directory}"
    book = Storys::Book.new(storys)
    book.path = directory
    book.generate_thumbnail
    books << book
  end

  def updated(book)
    puts "updating: #{book.inspect}"
    #
  end
end
