# encoding: UTF-8
require 'helper'


class RFFW::App::ViewHelpersTest < MiniTest::Unit::TestCase
  
  include RFFW::App::ViewHelpers
  
  
  def test_uri_unescape
    string = "Hola+Mundo.%0D%0A%0D%0A%3Cscript%3Ealert%28%27hey%27%29%3B%3C%2Fscript%3E"
    expected = "Hola Mundo.

<script>alert('hey');</script>"
    assert_equal expected, uri_unescape(string)
  end
  
  
  def test_uri_escape
    string = "hola ++  que tal € ‰"
    expected ='hola+%2B%2B++que+tal+%80+%89'
    assert_equal  expected, uri_escape(string)
  end
end