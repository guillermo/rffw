module RFFW::App::ViewHelpers
  
  CHARS = File.read(File.expand_path('../urlencode_chars.data',__FILE__)).split("\n")
  
  def uri_escape(string)
    string.gsub(/[^a-zA-Z0-9 ]/) do |char|
      CHARS.include?(char) ? "%#{"%.2X" % (CHARS.index(char)+32)}" : char
    end.tr(" ", "+")
  end

  def uri_unescape(string)
    string.gsub(/\%([a-f0-9]{2})/i) do |char|
      value = $1.to_i(16)
      case value
      when 32..(CHARS.size+32)
        CHARS[value - 32] || char
      when 13
        "\n"
      when 10
        '' #LF
      else
        "#{char}"
      end
    end.gsub("+", " ")
  end
  
  def strip_tags(string)
    string.gsub(/<(.|\n)*?>/m, '')
  end
end