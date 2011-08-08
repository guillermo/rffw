require 'helper'

class RFFW::Server::BufferedClientTest < MiniTest::Unit::TestCase
  include RFFW::Server
  def setup
    @socket = StringIO.new
    @client = BufferedClient.new(@socket)
    def @client.read_nonblock(arg) ; "h"*1000  end
    def @client.close ; end
  end

  def teardown
    BufferedClient.disconnect_all!
  end

  def test_on_small_data
    @client.on_data
    assert_equal "h"*1000, @client.buffer
    assert !@client.usign_temp_file?
  end
  
  def test_on_data
    def @client.read_nonblock(arg) ; "h"*2000  end
    @client.on_data
    assert_equal "h"*2000, @client.buffer
    assert @client.usign_temp_file?
  end
  
  def test_on_data_appending
    @client.on_data
    assert !@client.usign_temp_file?
    @client.on_data
    assert @client.usign_temp_file?
    assert_equal "h"*2000, @client.buffer
  end
  
  def test_clear_buffer
    @client.on_data 
    @client.clear_buffer
    assert_equal '', @client.buffer
  end
  
  def test_remove_file_on_clear_buffer
    @client.on_data
    @client.clear_buffer
    assert !@client.usign_temp_file?
  end
  
    
end
