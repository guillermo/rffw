# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rffw/version"

Gem::Specification.new do |s|
  s.name        = "rffw"
  s.version     = RFFW::VERSION
  s.authors     = ["Guillermo Álvarez"]
  s.email       = ["guillermo@cientifico.net"]
  s.homepage    = ""
  s.summary     = %q{Recive files from webserver}
  s.description = %q{A simple program that listen at port 80 for uploads, and save the uploaded files to disk}

  s.rubyforge_project = "rffw"

  s.files         = `git ls-files -- {lib,bin,README*}`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end
