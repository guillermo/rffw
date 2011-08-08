module RFFW::Server

  class Client < DelegateClass(TCPSocket)
    extend Enumerable

    @@clients = []

    def initialize(socket)
      Thread.exclusive {
        @@clients << self
      }
      super(socket)
    end

    def self.all
      Thread.exclusive {
        @@clients.uniq!
      }
      @@clients
    end

    def self.each(&block)
      @@clients.each(&block)
    end

    def self.find(client)
      @@clients.find{|c| c == client}
    end

    def self.find_by_io(client)
      @@clients.find{ |c| c.to_i == client.to_i }
    end

    def self.disconnect_all!
      while client = Thread.exclusive{@@clients.pop}
        client.on_disconnect 
      end
    end

    def finished?
      return  ((closed? || eof?) ? true : false)
    rescue Errno::ECONNRESET
      return true
    end

    def on_disconnect
      close unless closed?
      Thread.exclusive{ @@clients.delete self }
    end

    alias disconnect! on_disconnect
  end
end
