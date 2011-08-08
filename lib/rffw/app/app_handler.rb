module RFFW::App
  class AppHandler < RFFW::Server::HttpClient
    include RFFW::Server
    include RFFW::App::DirHandler
    include RFFW::App::UploadHandler
    include RFFW::App::UploadStatusHandler
    include RFFW::App::DescriptionHandler
    include RFFW::App::ShowHandler

    attr_reader :request

    def on_data
      super
      if request && request.post? && request.path == '/upload'
        memory_usage = `ps -o rss= -p #{$$}`.to_i
        $stderr.puts "[#{memory_usage}kB] #{Time.now.utc} #{fileno} (#{self.class.all.size}) UPLOADING A FILE: #{request.upload_progress}"
      end
    end

    def on_request(r)
      memory_usage = `ps -o rss= -p #{$$}`.to_i
      $stderr.puts "[#{memory_usage}Kb] #{Time.now.utc} #{fileno} (#{self.class.all.size}) > <#{r.inspect}>"

      response = case
      when ! %w(get post).include?(r.method.downcase)
        HttpResponse.new("Sorry! Method not allowed.", 405)
      when r.method.downcase == 'get' && r.path == '/upload_status.js'
        upload_status_handle(r)
      when r.method.downcase == "post" && r.path == '/upload'
        upload_handle(r)
      when r.method.downcase == "post" && r.path == '/description'
        description_handle(r)
      when r.method.downcase == 'get' && r.path == '/show'
        show_handle(r)
      when r.method.downcase == "get"
        dir_handle(r)
      else
        HttpResponse.new("No no no... Not found !", 404)
      end
      write response

    rescue => e
      $stderr.puts "#{e.message}\r\n#{e.inspect}\r\n#{e.backtrace.join("\n")}"
      write HttpResponse.new("#{e.message}\r\n#{e.inspect}\r\n#{e.backtrace.join("\n")}", 505)
    ensure
      cleanup!
    end

    def cleanup!
      on_disconnect unless request.keep_alive?
      @request = HttpRequest.new('')
      clear_buffer
    end

  end
end



