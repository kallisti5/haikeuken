worker_processes 2
working_directory "/var/rails/hpbs/"
 
preload_app true
timeout 120
listen "/var/rails/hpbs/tmp/sockets/unicorn.sock", :backlog => 64
pid "/var/rails/hpbs/tmp/pids/unicorn.pid"

#     # Set the path of the log files inside the log folder of the testapp
stderr_path "/var/rails/hpbs/log/unicorn.stderr.log"
stdout_path "/var/rails/hpbs/log/unicorn.stdout.log"

before_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.establish_connection
end
