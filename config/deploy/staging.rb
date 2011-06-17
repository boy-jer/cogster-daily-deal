role :web, "cogster.littleredbrick.net" #domain                          
role :app, "cogster.littleredbrick.net" #domain                          
role :db, "cogster.littleredbrick.net", :primary => true 
set :stage, :staging
set :deploy_to, "/srv/www/cogster/staging"
