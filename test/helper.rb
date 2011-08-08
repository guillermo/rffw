require 'minitest/unit'
require 'minitest/mock'
require 'rffw'
require 'stringio'
require 'tmpdir'

class MiniTest::Unit::TestCase

  def fixture(name)
    File.expand_path("../fixtures/#{name}", __FILE__)
  end

  def read(name)
    File.read(fixture(name))
  end

end


class IntegrationTest < MiniTest::Unit::TestCase

  def setup
    @port = 64444
    @server_pid = fork do
      $stdout = File.open("/dev/null",'w')
      $stderr = $stdout
      RFFW::App.start(@port,"127.0.0.1", Dir.mktmpdir("rffw_test"))
      exit(0)
    end
    sleep 0.1
  end

  def teardown
    Process.kill('SIGINT', @server_pid)
    Process.wait(@server_pid)
  end



  def upload_file(name)
    Fiber.new do
      fixture = read(name)
      socket = TCPSocket.new('127.0.0.1', @port)
      socket.write fixture[0..(fixture.size/3)]
      Fiber.yield

      socket.write fixture[(fixture.size/3)..(fixture.size/3*2)]
      Fiber.yield

      socket.write fixture[(fixture.size/3*2)..-1]
      Fiber.yield

      begin
        data = socket.read_nonblock(1024*1024*1024)
      rescue Errno::EAGAIN
        retry
      end

      Fiber.yield data
    end
  end

  def send_request(name)
    socket = TCPSocket.new('127.0.0.1', @port)
    socket.write read(name)
    begin
      content = socket.read_nonblock(1024*1024*1024).tap{ socket.close }.split("\r\n").last.strip
    rescue EOFError,Errno::EAGAIN
      retry
    end
  end

  def upload_file(name)
    Fiber.new do
      fixture = read(name)
      socket = TCPSocket.new('127.0.0.1', @port)
      socket.write fixture[0..(fixture.size/3)]
      Fiber.yield

      socket.write fixture[(fixture.size/3)..(fixture.size/3*2)]
      Fiber.yield

      socket.write fixture[(fixture.size/3*2)..-1]
      Fiber.yield

      data = nil
      while(data == nil)
        data = socket.read_nonblock(1000000) rescue nil
      end
      data

      Fiber.yield data
    end
  end


end