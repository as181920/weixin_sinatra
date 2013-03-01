require File.join(File.dirname(__FILE__),"server")
set :environment, :production
set :app_file,     'server.rb'
set :root, Pathname(__FILE__).dirname
disable :run

class Server
  configure :production do
    Dir.mkdir('log') unless File.exist?('log')

    Log = Logger.new File.join(File.dirname(__FILE__),"log","#{Sinatra::Base.environment}.log"), "weekly"
    #Log.level = Logger::WARN

    STDOUT.reopen("./log/#{Sinatra::Base.environment}_stdout.log", "w")
    STDOUT.sync = true
    STDERR.reopen(STDOUT)
  end 

  configure :development do
    Log = Logger.new(STDOUT)
  end 
end

#set :sessions, true
#set :logging, true
#set :dump_errors, false

run Server

