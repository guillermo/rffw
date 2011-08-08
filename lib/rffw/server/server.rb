module RFFW::Server
  class Server < TCPServer
    include RFFW::Server

    def initialize(handler = HttpClient, port = 8080, listen = "0.0.0.0" )
      @handler = handler
      super(listen,port)
      catch :ctrl_c do 
        loop do
          read, write, error = Kernel.select(@handler.all << self)
          read.each do |io|
            io == self ? process_server : process_client(io)
          end
        end
      end
    end
    
    private
    
    def process_server
      begin
        socket = accept_nonblock
        @handler.new(socket)
      rescue Errno::EAGAIN
      end
    end
    
    def process_client(io)
      begin
        if client = @handler.find_by_io(io)
          client.finished? ? client.on_disconnect : client.on_data
        else
          raise "Sorry. I don't know how to manage this situation"
        end
      rescue IOError => e
        $stderr.puts "Closed Stream"
        client.disconnect!
      rescue => e
        client.disconnect!
        $stderr.puts e.inspect
        $stderr.puts e.backtrace
      end
    end
    
  end
end
