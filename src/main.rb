require 'wikipedia'
require 'discordrb'
require 'net/https'
require 'open-uri'
require 'json'
require 'rest-client'
require 'nokogiri'
require 'cgi'
require 'reverse_markdown'

class Main
  def initialize
    $config = JSON.parse(File.read('config.json'))
    bot = Discordrb::Commands::CommandBot.new(token: $config['token'],
                                              client_id: $config['client_id'],
                                              prefix: $config['prefix'])
    Dir['commandExtensions/*.rb'].each { |file| require_relative file }
    Dir['commandExtensions/*.rb'].each do |file|
      botmodule = Object.const_get(File.basename(file, '.*'))
      bot.include! botmodule
    end
    $invite_url = bot.invite_url
    puts "This bot's invite URL is #{$invite_url}."
    puts 'Click on it to invite it to your server.'
    bot.run
  end
end

m Main.new
