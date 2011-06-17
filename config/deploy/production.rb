role :web, "www.cogster.com"
role :app, "www.cogster.com"
role :db, "www.cogster.com", :primary => true
set :stage, :production
set :deploy_to, "/srv/www/cogster/production"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn start /etc/unicorn/cogster.conf"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn stop /etc/unicorn/cogster.conf"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/unicorn restart /etc/unicorn/cogster.conf"
  end

end
