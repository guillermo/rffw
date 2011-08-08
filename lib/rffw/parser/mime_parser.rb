module RFFW::Parser
  module MimeParser
    extend self
    class Attachment < Struct.new(:boundary, :header, :data, :headers)

      def header=(header)
        return if header.nil?
        @headers = {}
        header.split("\r\n").each{|l| 
          head = l.split(":") 
          @headers[head[0]] = head[1].strip
        }
      end

      def content_disposition
        @headers.find{|k,v| k.downcase == 'content-disposition' }.last
      end
      
      def content_type
        @headers.find{|k,v| k.downcase == 'content-type' }.last
      end
      
      def filename
        content_disposition[/filename\=\"([^"]*)\"/i,1]
      end
      
      def to_s
        data
      end
    end
    def parse(string)
      scanner = StringScanner.new(string.force_encoding("BINARY"))
      attachments = []
      while !scanner.eos?
        attachment = Attachment.new
        attachment.boundary = scanner.scan_until(/\r\n/).strip
        attachment.header = scanner.scan_until(/\r\n\r\n/)
        pos = scanner.pos
        scanner.scan_until(/\r\n#{Regexp.escape attachment.boundary}/)
        attachment.data = scanner.pre_match.to_s[pos..-1]
          attachments << attachment unless attachment.data.nil?
      end
      attachments
    end
  end
end