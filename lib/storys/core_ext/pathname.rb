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
end
