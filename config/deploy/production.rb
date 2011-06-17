role :web, "www.cogster.com"
role :app, "www.cogster.com"
role :db, "www.cogster.com", :primary => true
set :stage, :production
set :deploy_to, "/srv/www/cogster/production"
