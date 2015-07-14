worker_processes 2
working_directory "/opt/apps/haikeuken/"
 
preload_app true
timeout 120
#listen "/opt/apps/haikeuken/tmp/sockets/unicorn.sock", :backlog => 64
listen 3000
pid "/opt/apps/haikeuken/tmp/pids/unicorn.pid"

#     # Set the path of the log files inside the log folder of the testapp
stderr_path "/opt/apps/haikeuken/log/unicorn.stderr.log"
stdout_path "/opt/apps/haikeuken/log/unicorn.stdout.log"

before_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.establish_connection
end
