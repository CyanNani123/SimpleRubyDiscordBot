require 'wikipedia'
require 'discordrb'
require 'net/https'
require 'open-uri'
require 'json'
require 'rest-client'
require 'nokogiri'
require 'cgi'
require 'reverse_markdown'

#main: Create a new ruby agent with your token and client_id, include all modules in the main application, load modules by bot from command container, make the bot actually connect
def main ()
	$config = JSON.parse(File.read("../config.json"))
	bot = Discordrb::Commands::CommandBot.new(token: $config["token"], client_id: $config["client_id"], prefix: $config["prefix"])
	Dir["Modules/*.rb"].each {|file| require_relative file }
	Dir["Modules/*.rb"].each {|file| 
	  botmodule = Object.const_get(File.basename(file, ".*"))
	  bot.include! botmodule }
	$invite_url = bot.invite_url  
	puts "This bot's invite URL is #{$invite_url}."
	puts 'Click on it to invite it to your server.'
	bot.run
end

main()
