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

# Pull settings from B_USER_SETTINGS_DIRECTORY/hpbs.yml
settings_dir = `finddir B_USER_SETTINGS_DIRECTORY`.delete!("\n")
@settings = YAML::load_file("#{settings_dir}/hpbs.yml")
@remote_uri = "#{@settings['server']['url']}/builders/#{@settings['general']['hostname']}"

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

def refrepo()
	# Clone or update haikuporter
	if ! Dir.exists?("./haikuporter")
		`git clone https://bitbucket.org/haikuports/haikuporter.git ./haikuporter`
	else
		Dir.chdir("./haikuporter")
		`git pull --rebase`
		Dir.chdir(@settings['general']['work_path'])
	end

	# Check for haikuporter
	if ! File.exist?("./haikuporter/haikuporter")
		puts "Haikuporter missing after clone / update!"
		exit 1
	end

	# Clone or update haikuports
	if ! Dir.exists?("./haikuports")
		`git clone https://bitbucket.org/haikuports/haikuports.git ./haikuports`
	else
		Dir.chdir("./haikuports")
		`git pull --rebase`
		Dir.chdir(@settings['general']['work_path'])
	end
end


def loop()
	puts "+ Refreshing repos..."
	refrepo()

	puts "+ Checking for new work..."

	work = getwork()

	# The server could also return a list of tasks,
	# and we could do work.each. For now we just
	# do one task.

	task = work

	if task == nil
		puts "- No work available"
		return 0
	end
	
	puts "+ Work received"
	puts "+ Building #{task['name']}-#{task['version']}-#{task['revision']}"

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
	loop()
	puts "+ Resting for #{@rest_period} seconds..."
	sleep(@rest_period)
end
