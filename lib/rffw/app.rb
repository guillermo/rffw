
module RFFW
  module App
    require 'rffw/app/db'
    require 'rffw/app/record'

    require 'rffw/app/view_helpers'
    require 'rffw/app/upload_handler'
    require 'rffw/app/upload_status_handler'
    require 'rffw/app/dir_handler'
    require 'rffw/app/description_handler'
    require 'rffw/app/show_handler'

    require 'rffw/app/app_handler'

    def self.start(port = 8080, listen = "127.0.0.1", dir = Dir.pwd)
      trap("SIGINT") { throw :ctrl_c }
      @@dir = dir
      start_db(@@dir)
      server = RFFW::Server::Server.new( RFFW::App::AppHandler, port, listen )
    end
    
    def self.start_db(dir)
      @@db = Db.new(File.join(dir,'rffw'))
    end
    
    def self.db
      @@db
    end
    
    def self.dir
      @@dir
    end
    
  end
end
