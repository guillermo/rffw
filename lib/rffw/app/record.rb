class RFFW::App::Record
  
  ATTRIBUTES = %w(mime_type filename description)
  
  attr_reader :id
  attr_accessor :attributes
  
  def initialize(id, hash = {})
    @id = id
    @attributes = hash
  end
  
  def new?
    RFFW::App.db[id].empty?
  end
  
  def self.find_by_id(id)
    new(id, RFFW::App.db[id])
  end
  
  def self.update_or_create_by_id(id, hash, body = nil)
    find_by_id(id).tap{ |record|
      record.body = body unless body.nil?
      record.attributes = record.attributes.merge(hash) unless hash.nil?
      RFFW::App.db[id] = record.attributes      
    }
  end

  def body=(body)
    File.open(@id,'w'){|f| f.write body}
  end

  ATTRIBUTES.each do |attr_name|
    define_method(attr_name.to_sym) do
      @attributes[attr_name]
    end
  end
  
  
  def body
    File.read(@id) if File.file?(@id)
  end
end