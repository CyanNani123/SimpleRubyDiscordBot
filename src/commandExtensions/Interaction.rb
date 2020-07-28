# @example give user a friendly octopus
#  ~oct
# display time of host
#  ~time
# answer question randomly like 8ball
#  ~question <question sentence>
# show invite link
#  ~invite
module Interaction
  extend Discordrb::Commands::CommandContainer

  command(:oct, max_args: 1) do |event, *args|
    event.respond(args.join(' ') + ' received a friendly :octopus: from ' + event.user.name.to_s + '!')
  end

  command(:time, max_args: 0) do |event|
    time = Time.now.to_s
    event.respond('Current Time : ' + time)
  end

  command(:question, min_args: 1) do |event|
    zufallszahl = rand(3)
    case zufallszahl
    when 0
      answer = 'Yes, indeed.'
    when 1
      answer = 'No, of course not.'
    when 2
      answer = "Maybe, I can't say for sure."
    end
    event.respond(answer)
  end

  command(:invite, max_args: 0) do |event|
    event.respond("This bot's invite URL is ```#{$invite_url}```")
  end
end
