module RFFW::App::UploadStatusHandler
  include RFFW::Parser
  include RFFW::App::UploadHandler

  def upload_status_handle(request)
    uploads = uploads_for_id(request.query)

    attributes = Record.find_by_id(request.query).attributes || {}
    attributes["progress"] = uploads.first.request.upload_progress if uploads.any?

    if attributes.keys.any?
      HttpResponse.new(hash_to_json(attributes).to_s, 200)
    else
      HttpResponse.new("Not found upload.", 404)
    end
  end


  protected

  def hash_to_json(hash)
    values = hash.map{|k,v| %{"#{escape_json(k.to_s)}": "#{escape_json(v.to_s)}"} }.join(", ")
    "{ #{values} }"
  end

  def escape_json(code)
    code.gsub('"','\"')
  end

  def uploads_for_id(id)
    RFFW::App::AppHandler.select do |connection|
      connection.is_a?(RFFW::App::AppHandler) &&
      connection.respond_to?(:request) &&
      connection.request &&
      connection.request.post? &&
      connection.request.path == "/upload" &&
      connection.request.query == request.query
    end
  end
end