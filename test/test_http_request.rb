require 'helper'

class RFFW::Server::HttpRequestTest < MiniTest::Unit::TestCase

  include RFFW::Parser

  def setup
    @simple_request = File.read(File.expand_path("../fixtures/raw_request.txt",__FILE__))
    @request_headers = {"HTTP_METHOD"=>"GET",
     "HTTP_PATH"=>"/",
     "HTTP_VERSION"=>"1.1",
     "Host"=>"localhost:9999",
     "User-Agent"=>
      "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1",
     "Accept"=>
      "application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5",
     "Accept-Language"=>"en-us",
     "Accept-Encoding"=>"gzip, deflate",
     "Connection"=>"keep-alive"}
  end

  def test_parse_simple_request
    request = HttpRequest.new(@simple_request.dup)
    assert request.headers.is_a?(Hash), "headers should be a hash"
    assert request.body.is_a?(String), "body should be a string"
    assert request.finish?, "request should be finished"
    assert_equal(@request_headers, request.headers)
    %w(attachments upload_content_lenght body_size upload_progress).each do |method|
      assert_raises(HttpRequest::OnlyForPosts, "#{method} should raise exception for get requests.") { request.send(method.to_sym) }
    end

    assert_equal "1.1", request.version
    assert_equal "/", request.path
    assert_equal true, request.keep_alive?
    assert_equal "GET", request.method
    assert_equal '', request.query
    assert_equal '/', request.url
    assert_kind_of URI, request.uri
  end

  def test_incomplete_request
    raw_request = @simple_request[0..(@simple_request.size/2)]
    request = HttpRequest.new(raw_request)
    assert !request.finish?
  end
  
  def test_post_form_data
    request = HttpRequest.new(read('post_form_data.http'))
    assert_equal( {"description"=>"hola"}, request.post_form_data)
    
  end
end
