require 'bundler/capistrano'
set :application,         "cogster"
set :user,                "deploy"
set :use_sudo,            false
set :domain,              "173.230.132.11"

set :scm,                 "git"
set :repository,          "git@github.com:bgates/cogster.git"

set :git_shallow_clone,   1
set :keep_releases,       5

set :runner,              "deploy"
set :stages, %w(staging production)
set :default_stage, "staging"

ssh_options[:paranoid]    = false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :rails_env, :production
set :unicorn_binary, "/usr/bin/unicorn"
set(:unicorn_config) { "#{current_path}/config/unicorn.rb" }
set(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }

after :deploy, :remove_test_files
after :deploy, :replace_runner

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn start /etc/unicorn/cogster.conf"
    #run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn stop /etc/unicorn/cogster.conf"
    #run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #stop
    #start
    sudo "/etc/init.d/unicorn restart /etc/unicorn/cogster.conf"
  end

end

desc "Remove test files" 
task :remove_test_files, :roles => :web do
  sudo "rm -rf #{current_path}/features/"
  sudo "rm -rf #{current_path}/spec/"
  sudo "rm #{current_path}/lib/tasks/cucumbercov.rake"
end

desc "replace rails runner w version which has server-appropriate path"
task :replace_runner, :roles => :web do
  sudo "mv -f #{current_path}/script/rails.server #{current_path}/script/rails"
end

require 'capistrano/ext/multistage'
