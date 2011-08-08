require 'helper'

class RFFW::Server::ClientTest < MiniTest::Unit::TestCase
  include RFFW::Server

  def setup
    @socket = StringIO.new
    def @socket.close; nil end
  end

  def teardown
    Client.disconnect_all!
  end

  def test_initialize
    client = Client.new(@socket)
    assert client.instance_of?(Client)
  end

  def test_find
    client = Client.new(@socket)
    assert_equal Client.find(client), client
  end

  def test_is_enumerable
    assert Client.singleton_class.included_modules.include?(Enumerable)
  end

  def test_each
    expected = [Client.new(@socket), Client.new(@socket)]
    result = []
    Client.each{|c| result << c }
    assert_equal expected, result
  end

  def test_all
    expected = [Client.new(@socket), Client.new(@socket)]
    assert_equal expected, Client.all
  end

  def test_on_disconnect
    client = Client.new(@socket)
    assert Client.all.any?
    client.disconnect!
    assert Client.all.empty?
  end
end
