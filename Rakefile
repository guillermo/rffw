require 'bundler/gem_tasks'
require 'rake/testtask'


Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = false
end

task :default do 
  
  begin 
    require 'rubygems'
    gem 'minitest'
    require 'minitest/pride'
  rescue LoadError, Gem::LoadError
    $stderr.puts "Minitest gem not found. Usign ruby minitest."
  end

  base = File.expand_path("..", __FILE__)
  $:.unshift File.join(base,"lib")
  $:.unshift File.join(base,'test')
  Dir[File.expand_path("../test/test_*", __FILE__)].each{|f| require f}
  MiniTest::Unit.autorun
  
end

desc "Run the server"
task :run do
  exec("ruby -rubygems -I lib bin/rffw")
end


task :commit do
  system("git add . && git commit -m 'WIP' && git push origin master:master")
end

task :deploy => [:commit] do
  system(%{ssh soundcloud "sudo su - guillermo ; cd rffw && git pull && sudo killall "})
end