#!/bin/ruby

##########################################
# Settings
##########################################
## General settings
@threads	= 1
@haikuports	= "/boot/home/haikuports"
@haikuporter	= "/boot/home/haikuporter"

## Node settings
@remote_host	= "http://haikungfu.net:3000"
@node_token	= "ewrtew345435643ydrsfy"
##########################################

##########################################
# Requirements
##########################################
require 'json'
require 'net/http'
##########################################

##########################################
# Global variables
##########################################
#@hostname = `hostname -s`.delete!("\n")
@hostname = "macmini32"
@remote_uri = "#{@remote_host}/builders/#{@hostname}"
##########################################

def getwork()
	uri = URI("#{@remote_uri}/getwork?token=#{@node_token}")
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

work = getwork()

# Just print out each task for now
work.each do | task |
	puts "#{task['name']}-#{task['version']}-#{task['revision']}"
end
