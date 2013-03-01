require File.join(File.dirname(__FILE__),"server")
set :environment, :production
set :app_file,     'server.rb'
set :root, Pathname(__FILE__).dirname
disable :run
run Server

