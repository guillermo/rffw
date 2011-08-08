module RFFW::App::DirHandler
  include RFFW::Parser
  
  def dir_handle(request)
    file = request.path == '/' ? '/index.html' : request.path
    if file = file_info(file)
      mime, content = file
      HttpResponse.new(content, 200, {"Content-Type" => mime}, request.keep_alive? ? "1.1" : "1.0")
    else
      HttpResponse.new("File not found", 404)
    end
  end
  
  protected
  
  def file_info(file)
    file_path = File.expand_path("../data/#{file}",__FILE__)
    if File.file?(file_path)
      content = File.read(file_path)
      mime = get_mime(file_path)
      [mime,content]
    else
      nil
    end
  end

  def get_mime(file)
    case file.split('.').last.downcase
    when 'png' then 'image/png'
    when 'html' then 'text/html'
    when 'js' then 'application/javascript'
    when 'css' then 'text/css'
    else 'text/html'
    end
  end
end