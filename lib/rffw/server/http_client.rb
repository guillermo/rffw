module RFFW::Server
  class HttpClient < BufferedClient
    include RFFW::Parser
    attr_reader :request

    def initialize(*args)
      super
    end

    def on_data
      super
      @request = process_request(self.buffer)
      on_request(request) if @request.finish?
    end

    def on_request(request)
      message = "Not found"
      write ["HTTP/1.1 404 Not found",
      "Server: rffw/#{RFFW::VERSION}",
      "Date: #{Time.now.httpdate}",
      "Content-Type: text/html",
      "Content-Length: #{message.size}",
      "Last-Modified: #{Time.now.httpdate}",
      "Connection: keep-alive",
      "Accept-Ranges: bytes",
      "",
      "#{message}"].join("\r\n")
    end

    def write_chunk(message)
      unless defined?(@headers_sent) && @headers_sent == true
        write HttpResponse.new("", 200, {"Transfer-Encoding" => "chunked"},'1.1')
        @headers_sent = true
      end
      write generate_chunk(message)
    end

    protected

    def generate_chunk(text)
      "#{text.size.to_s(16).upcase}\r\n#{text}\r\n\r\n"
    end

    def process_request(raw_request)
      HttpRequest.new(raw_request)
    end

  end
end
