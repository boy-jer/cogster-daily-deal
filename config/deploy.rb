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
