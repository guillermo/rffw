require 'helper'

class RFFW::App::UploadHandlerTest < IntegrationTest
  include RFFW::App::UploadHandler
  
  def test_upload_status
    response = send_request("upload.http")
    assert_equal 'So... Ok. Excelent.',response
  end
end
