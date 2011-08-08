module RFFW::Parser
  class HttpResponse

    def initialize(message, status = 200, headers = {"Content-Type" => 'text/html'}, version = "1.1" )
      @message, @status, @headers, @version = message, status, headers, version
    end

    def to_s
      headers = @headers.map{|k,v|
        "#{k}: #{v}\r\n"
      }.join('')
      
      response = ""
      response << "HTTP/#{@version} #{@status.to_s}\r\n"
      response << "Server: rffw/#{RFFW::VERSION}\r\n"
      response << "Date: #{Time.now.httpdate}\r\n"
      response << headers
      
      if @headers["Transfer-Encoding"] && @headers["Transfer-Encoding"] == "chunked"
        response << "\r\n"
      else
        response << "Content-Length: #{@message.size}\r\n" <<
        "\r\n#{@message}"
      end
      response
    end
    
  end
end
