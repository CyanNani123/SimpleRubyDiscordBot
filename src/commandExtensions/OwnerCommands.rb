# @example shutdown bot
#  ~shutdown
# @example restart bot
#  ~restart
module OwnerCommands
  extend Discordrb::Commands::CommandContainer

  command(:shutdown, max_args: 0) do |event|
    if event.user.id == $config['owner_id']
      event.respond('Goodnight, friends.')
      exit
    else
      event.respond("I'm sorry but you must be owner to use this function.")
    end
  end

  command(:restart, max_args: 0) do |event|
    if event.user.id == $config['owner_id']
      m = event.respond('Restarting...')
      sleep 1
      m.edit('Restart successfully executed!')
      exec('ruby .\SimpleRubyDiscordBot.rb')
    else
      event.respond("I'm sorry but you must be owner to use this function.")
    end
  end
end
