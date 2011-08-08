module RFFW::Parser
  class HttpRequest

    class MalformedReqest < StandardError ; end
    class IncompleteRequest < StandardError ; end
    class OnlyForPosts < StandardError; end
    
    attr_reader :headers

    def initialize(raw_request)
      @headers={}
      @headers_are_parsed = false
      scan(raw_request)
    rescue IncompleteRequest

    end

    def finish?
      if get? && @headers_are_parsed
        true
      elsif post? && @headers_are_parsed && upload_content_lenght <= body_size
        true
      else
        false
      end
    end
    
    def body
      post? ? @body : @body || ""
    end

    def attachments
      raise OnlyForPosts unless post?
      MimeParser.parse(@body)
    end

    def method
      @headers["HTTP_METHOD"]
    end

    def path
      uri && uri.path
    end

    def query
      uri && uri.query || ""
    end

    def url
      @headers["HTTP_PATH"]
    end

    def uri
      URI.parse(url)
    rescue
      nil
    end

    def version
      @headers["HTTP_VERSION"]
    end

    def keep_alive?
      !!(version == '1.1' && @headers["Connection"] =~ /keep-alive/)
    end

    def post?
      method && method.downcase == "post"
    end

    def get?
      method && method.downcase == 'get'
    end

    def uplad_info
      @headers["Content-Length"].to_i - @body.size
    end

    def upload_content_lenght
      raise OnlyForPosts unless post?
      @headers["Content-Length"].to_i
    end

    def body_size
      raise OnlyForPosts unless post?
      @body.size
    end

    def upload_progress
      raise OnlyForPosts unless post?
      "#{body_size}/#{upload_content_lenght}"
    end


    def post_form_data
      body.split("&").inject({}){|memo, value|
        key,value = value.split("=")
        memo[key] = value
        memo
      }
    end
    
    def inspect
      "#{method} #{path} #{query} #{version}"
    end

  protected
    def scan(raw)
      return nil unless raw.is_a?(String)
      full_scanner = StringScanner.new(raw.force_encoding("BINARY"))
      
      headers = full_scanner.scan_until(/\r\n\r\n/) or raise IncompleteRequest
      scan_headers(headers)
      
      @body = full_scanner.rest
    end

    def scan_headers(headers)
      scanner = StringScanner.new(headers)
      
      @headers["HTTP_METHOD"] = scanner.scan(/\w+/) or raise MalformedReqest
      scanner.scan(/\s+/)
      @headers["HTTP_PATH"] = scanner.scan(/\S+/) or raise MalformedReqest
      scanner.scan(/\s+HTTP\//) or raise MalformedReqest
      @headers["HTTP_VERSION"] = scanner.scan(/\S+/) or raise MalformedReqest
      begin
        scanner.scan(/\r\n/)
        break if scanner.scan(/\r\n/) || scanner.eos?
        key = scanner.scan(/\A[^:]+/) or break
        scanner.scan(/\:\s*/) or break
        value = scanner.scan(/.*\r\n/) or break
        @headers[key] = value.strip if key && value
      end while (key && value)
      @headers_are_parsed = true
    end
  end
end
