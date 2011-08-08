require 'helper'

class RFFW::Server::MimeTest < MiniTest::Unit::TestCase
  include RFFW::Parser

  def setup
    @data = File.read(File.expand_path('../fixtures/mime_image.data', __FILE__))
    @image_data = File.read(File.expand_path('../fixtures/mime_image.png', __FILE__)).force_encoding("BINARY")
  end

  def test_mime_parser
    attachments     = MimeParser.parse(@data)
    attachment      = attachments.first
    expected_header = "form-data; name=\"file\"; filename=\"Screen shot 2011-08-05 at 5.42.34 AM.png\""
    image_type      = "image/png"
    
    assert_equal 1, attachments.size
    assert_equal expected_header, attachment.content_disposition
    assert_equal image_type, attachment.content_type
    assert_equal @image_data, attachment.to_s, "to be equal"
  end
end
