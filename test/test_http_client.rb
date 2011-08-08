require 'helper'

class RFFW::Server::HttpClientTest < MiniTest::Unit::TestCase
  include RFFW::Server

  def setup
    @mock_socket = MiniTest::Mock.new
    @mock_socket.expect(:close, nil)
    @mock_socket.expect(:read_nonblock, File.read(fixture('raw_request.txt')),[String])
    @mock_socket.expect(:closed?, nil)
    @mock_socket.expect(:write, nil,[String])
  end

  def teardown
    HttpClient.disconnect_all!
  end

  def test_request
    client = HttpClient.new(@mock_socket)
    def client.buffer; File.read(File.expand_path("../fixtures/raw_request.txt",__FILE__)) ; end
    client.on_data
    assert File.read(fixture("raw_request.txt")), client.on_data
  end


end
