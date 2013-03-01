set :environment, :production
set :root, Pathname(__FILE__).dirname
disable :run
require File.join(File.dirname(__FILE__),"server")
run Server

