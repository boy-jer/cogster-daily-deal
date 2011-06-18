role :web, domain                          
role :app, domain                          
role :db, domain, :primary => true 
set :stage, :staging
set :deploy_to, "/srv/www/cogster/staging"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn start /etc/unicorn/cogster_staging.conf"
    #run "cd #{current_path} && #{try_sudo} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn stop /etc/unicorn/cogster_staging.conf"
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
    update_unicorn_config
    sudo "/etc/init.d/unicorn restart /etc/unicorn/cogster_staging.conf"
  end

  task :update_unicorn_config do
    run "mv #{current_release}/config/unicorn.rb.staging #{current_release}/config/unicorn.rb"

  end
end
