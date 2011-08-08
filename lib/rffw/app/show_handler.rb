module RFFW::App::ShowHandler
  include RFFW::Parser
  include RFFW::App
  include RFFW::App::ViewHelpers
  
  def show_handle(request)
    id, options = request.query.split("&")
    record = Record.find_by_id(id) unless id.nil?
    return HttpResponse.new(in_template("not found"), 404) if !record || record.new?
    
    if options == "download"
      HttpResponse.new(record.body.force_encoding("BINARY"), 200, {"Content-Type" => record.mime_type})
    else
      body = "<h1><a href=\"/show?#{record.id}&download\">#{record.filename}</a></h1><p>#{strip_tags(uri_unescape(record.description))}</p>"
      HttpResponse.new(in_template(body))
    end
  end
  
  protected

  def in_template(content)
    File.read(File.expand_path("../data/template.html",__FILE__)).gsub("THE_BODYer", content)
  end
  
end