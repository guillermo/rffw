module RFFW::Server
  class BufferedClient < Client
    
    @@buffer_size = 1024

    def initialize(*args)
      super
      @buffer = ''
      @file = nil
    end

    def on_data
      data = self.read_nonblock 1024*1024*1024
      if !@file && @buffer.size + data.size > @@buffer_size
        @file = Tempfile.new('rffw_request')
        @file.write @buffer
        @file.write data
        @buffer = nil
      elsif @file
        @file.write data
      else
        @buffer << data
      end
    end
    
    def usign_temp_file?
      !!@file
    end
    
    def buffer_io
      usign_temp_file? ? @file : @buffer
    end
    
    def on_disconnect
      clear_buffer
      super
    end
    
    def buffer
      if @file
        @file.rewind
        @file.read
      else
        @buffer
      end
    end
    
    def clear_buffer
      if @file
        @file.close
        @file.unlink
        @file = nil
      end
      @buffer = ''
    end
  end
end