module RFFW::App::UploadHandler
  include RFFW::Parser
  include RFFW::App

  def upload_handle(request)
    if request.query.nil? || request.query.empty?
      HttpResponse.new("File not found", 404)
    else
      id = request.query
      attachment = request.attachments.first
      if attachment
        Record.update_or_create_by_id(id, {"mime_type" => attachment.content_type, "filename"  => attachment.filename}, attachment.to_s)
        HttpResponse.new("So... Ok. Excelent.",202)
      else
        HttpResponse.new("415 Unsupported Media Type", 415)
      end
    end
  end

  def uploading_data?
    request && request.post? && request.path == "/upload"
  end

  def uploads_for_query(query)
    self.class.select do |socket|
      socket.respond_to?(:uploading_data?) &&
      socket.uploading_data? &&
      socket.request.query == query
    end
  end

end