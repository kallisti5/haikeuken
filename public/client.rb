#!/bin/ruby

@version = "0.1"
@rest_period = 5.0

##########################################
# Requirements
##########################################
require 'json'
require 'net/http'
require 'yaml'
#require 'colorize'
##########################################

# Pull settings from B_USER_SETTINGS_DIRECTORY/haikeuken.yml
settings_dir = `finddir B_USER_SETTINGS_DIRECTORY`.delete!("\n")
@settings = YAML::load_file("#{settings_dir}/haikeuken.yml")
@remote_uri = "#{@settings['server']['url']}/builders/#{@settings['general']['hostname']}"

@porter_arguments = "-y -v --no-dependencies"

#puts @settings.inspect

def getwork()
	uri = URI("#{@remote_uri}/getwork?token=#{@settings['general']['token']}")
	begin
		json = JSON.parse(Net::HTTP.get(uri))
	rescue
		puts "=========================================="
		puts "Error: Server #{uri}"
		puts "  Returned invalid JSON data!"
		return nil
	end
	return json
end


def putwork(status, buildlog, build_id)
	uri = URI("#{@remote_uri}/putwork")

	#req = Net::HTTP::Post.new(uri.request_uri)
	#req.set_form_data('result' => result)

	log = File.open(buildlog, "rb")

	begin
		Net::HTTP.post_form uri, {"token" => @settings['general']['token'],
			"status" => status, "build_id" => build_id,
			"result" => log.read}
		#Net::HTTP.start(uri.hostname, uri.port) do |http|
		#	http.request(req)
		#end
	rescue
		puts "=========================================="
		puts "Error: Server #{uri}"
		puts "=========================================="
		log.close
		return nil
	end
	log.close
end


def refrepo()
	# Clone or update haikuporter
	if ! Dir.exists?("./haikuporter")
		system 'git clone https://bitbucket.org/haikuports/haikuporter.git ./haikuporter'
	else
		Dir.chdir("./haikuporter")
		system 'git pull --rebase'
		Dir.chdir(@settings['general']['work_path'])
	end

	# Check for haikuporter
	if ! File.exist?("./haikuporter/haikuporter")
		puts "Haikuporter missing after clone / update!"
		exit 1
	end

	# Clone or update haikuports
	if ! Dir.exists?("./haikuports")
		system 'git clone https://bitbucket.org/haikuports/haikuports.git ./haikuports'
	else
		Dir.chdir("./haikuports")
		system 'git pull --rebase'
		Dir.chdir(@settings['general']['work_path'])
	end
end


def loop()
	puts "+ Checking for new work..."

	work = getwork()

	# The server could also return a list of tasks,
	# and we could do work.each. For now we just
	# do one task.

	if work == nil or work.count == 0
		puts "- No work available"
		return 0
	end
	
	work.each do |task|
		puts "+ Work received"
		worklog = "/tmp/#{task['name']}-#{task['version']}-#{task['revision']}.log"
		puts "+ Building #{task['name']}-#{task['version']}-#{task['revision']}"
		result = system "#{@settings['general']['work_path']}/haikuporter/haikuporter #{@porter_arguments} #{task['name']}-#{task['version']} &> #{worklog}"
		status = result ? "OK" : "Fail"
		putwork(status, worklog, task['id'])
    end
end

puts "Haiku Package Build System Client #{@version}"
puts "  Server: #{@settings['server']['url']}"
puts "  Threads: #{@settings['general']['threads']}"
puts "  Work Path: #{@settings['general']['work_path']}"
puts ""
puts "+ Entering main work loop..."

# Create work_path if it doesn't exist
if ! Dir.exists?(@settings['general']['work_path'])
	Dir.mkdir(@settings['general']['work_path'])
end
Dir.chdir(@settings['general']['work_path'])
	
while(1)
	# Disabled for testing
	#puts "+ Refreshing repos..."
	#refrepo()

	loop()
	puts "+ Resting for #{@rest_period} seconds..."
	sleep(@rest_period)
end
