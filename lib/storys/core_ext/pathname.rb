class Pathname
  def descendant_files
    out = children.select { |p| p.html? && !p.hidden? }
    children.select { |p| p.directory? && !p.hidden? }.each do |p|
      out += p.descendant_files
    end
    out
  end

  def html?
    file? && %w(.html).include?(extname)
  end

  def hidden?
    basename.to_s[0..0] == "."
  end

  def update_ext(extension)
    return self if extname == extension
    Pathname.new("#{to_s}#{extension}")
  end

  def write(content, options = {})
    preserve_mtime = options.delete(:preserve_mtime)
    _atime, _mtime = atime, mtime if preserve_mtime

    open("w", options) { |file| file << content }

    utime(_atime, _mtime) if preserve_mtime
  end
end
