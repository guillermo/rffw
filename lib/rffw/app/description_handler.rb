module RFFW::App::DescriptionHandler
  include RFFW::Parser
  include RFFW::App

  def description_handle(request)
    Record.update_or_create_by_id(request.query, request.post_form_data)
    to_path = "/show?#{request.query}"
    HttpResponse.new("Redirect to #{to_path}", 302, {"Location" => to_path})
  end


end