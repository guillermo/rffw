require 'helper'

class RecordTest < MiniTest::Unit::TestCase
  include RFFW::App
  
  def setup
     RFFW::App.start_db(Dir.mktmpdir("rffw_test"))
  end
    
  def test_update_or_create_by_id_on_create
    record = Record.update_or_create_by_id('1234', {"mime_type" => "text/plain", "filename" => "hello_world.txt"}, 'HOLA MUNDO')
    assert_equal '1234', record.id
    assert_equal 'text/plain', record.mime_type
    assert_equal 'hello_world.txt', record.filename
    assert_equal 'HOLA MUNDO', record.body
  end
  
  
  
  def test_update_or_create_by_id_on_update
    record = Record.update_or_create_by_id('1234', {"mime_type" => "text/plain", "filename" => "hello_world.txt"}, 'HOLA MUNDO')
    record = Record.update_or_create_by_id('1234', {"description" => "good file"})
    
    assert_equal 'good file', record.description
    assert_equal '1234', record.id
    assert_equal 'text/plain', record.mime_type
    assert_equal 'hello_world.txt', record.filename
    assert_equal 'HOLA MUNDO', record.body
  end
  
  def test_find_by_id
    record = Record.update_or_create_by_id('1234', {"mime_type" => "text/plain", "filename" => "hello_world.txt"}, 'HOLA MUNDO')
    
    record = Record.find_by_id('1234')
    assert_equal nil, record.description
    assert_equal '1234', record.id
    assert_equal 'text/plain', record.mime_type
    assert_equal 'hello_world.txt', record.filename
    assert_equal 'HOLA MUNDO', record.body
  end
  
  def test_new
    record = Record.new('123', {'asdf' => 3})
    assert record.new?, "should be new"
    
    record = Record.update_or_create_by_id('890123', {'asdf' => 3})
    assert !record.new?, "should not be new on existing record"
  end
end