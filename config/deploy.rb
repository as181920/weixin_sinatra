# Bundler tasks
require 'bundler/capistrano'
require 'rvm/capistrano'
set :rvm_ruby_string ,  'ruby-1.9.3-p194@askjane' #这个值是你要用rvm的gemset。名字要和系统里有的要一样。
set :rvm_type, :user

set :stages, %w(online)
set :default_stage, "online"
require 'capistrano/ext/multistage'

# do not use sudo
set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }


# This is needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :application, "weixin_sinatra"

set :scm, :git
set :branch, "master"

set :user, "bbt"
set :runner, user

set :host, "#{user}@bbtang.com" # We need to be able to SSH to that box as this user.
role :web, host
role :app, host

set :deploy_via, :remote_cache
set :deploy_env, 'production'
set :deploy_to, "/home/#{user}/bbtang/#{application}"

set :keep_releases, 10

after 'deploy:update_code', 'deploy:migrate', "deploy:create_symlink", "rvm:trust_rvmrc", "deploy:cleanup"

namespace :deploy do

  task :start, :roles => :app, :except => { :no_release => true } do
    #run "cd #{current_path} && passenger start --socket /tmp/passenger.socket --daemonize --environment production"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    #run "cd #{current_path} && passenger stop --pid-file tmp/pids/passenger.pid"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

task :uname do
    run "uname -a"
end

