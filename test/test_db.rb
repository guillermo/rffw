require 'helper'

class RFFW::App::DbTest < MiniTest::Unit::TestCase

  include RFFW::App
  
  def setup
    @db = Db.new(File.join(Dir.mktmpdir("rffw-test"),'test_db'))
  end

  
  def test_get_set
    assert_equal( {}, @db['12345'])
    assert_equal( {:a => 3}, (@db['12345'] = {:a => 3}), 'should retun value on set')
    assert_equal( {:a => 3}, @db['12345'], 'should return previous stored value on get')
  end
  
  
end