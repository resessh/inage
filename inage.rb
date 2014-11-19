#!/home/resessh/.rbenv/shims/ruby
# coding: utf-8

require 'net/http'
require 'date'

require './conf.rb'
require './class.rb'

def yoall
	yo_uri = URI.parse('http://api.justyo.co/yoall/')
	query = URI.escape('api_token=' + YO_TOKEN)
	Net::HTTP.start(yo_uri.host, yo_uri.port) do |http|
		http.post(yo_uri.path, query)
	end
end

def process
	new_empty = Inage.new.get_empty
	log = Log.new
	last_empty = log.get_last_empty
	yoall if new_empty > last_empty
	log.write(new_empty)
end

process if ACTIVE