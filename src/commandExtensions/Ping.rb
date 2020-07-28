# @example returns pong
#  ~ping
module Ping
  extend Discordrb::Commands::CommandContainer

  command(:ping, max_args: 0) do |event|
    event.respond('Pong!')
  end
end
