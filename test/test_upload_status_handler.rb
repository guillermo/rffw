require 'helper'

class RFFW::App::UploadStatusHandlerTest < IntegrationTest
  def test_upload_status
    uploader = upload_file("upload.http")

    assert_equal "Not found upload.", send_request("upload_status_request.http")

    uploader.resume #send chunk one
    assert_equal "{ \"progress\": \"6759/21534\" }", send_request("upload_status_request.http")
    
    uploader.resume
    assert_equal "{ \"progress\": \"14162/21534\" }", send_request("upload_status_request.http")
    
    uploader.resume
    assert_equal "{ \"mime_type\": \"application/pdf\", \"filename\": \"guillermoalvarez.pdf\" }", send_request("upload_status_request.http")
  end
end