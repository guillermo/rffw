require 'yaml'

class RFFW::App::Db
  
  class OnlyHashAllowed < StandardError ; end
    
  def initialize(filename)
    @filename = filename
  end
  
  def [](key)
    load_database[key] || {}
  end
  
  def []=(key,value)
    raise OnlyHashAllowed unless value.is_a?(Hash)
    database = load_database
    database[key] = value
    write_database(database)
  end
  
  protected
  
  def load_database
    return {} unless File.file? @filename
    Marshal.load(File.read(@filename).force_encoding("BINARY"))
  end
  
  def write_database(database)
    File.open(@filename,'w'){|f| f.write Marshal.dump(database)}
  end
  
end