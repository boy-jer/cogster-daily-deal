# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
worker_processes 2
# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory "/srv/www/cogster/production/current"
# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/cogster.socket", :backlog => 64
# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30
user 'deploy', 'deploy'
shared_path = '/srv/www/cogster/production/shared'
# feel free to point this anywhere accessible on the filesystem
pid "#{shared_path}/pids/unicorn.pid"
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

before_fork do |server, worker|
  old_pid = "#{shared_path}/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ERSCH
      #process killed already
    end
  end
end

