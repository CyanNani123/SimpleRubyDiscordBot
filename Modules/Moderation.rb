#@example ban user
#  ~ban @<userid> <amount of history to delete in days>
#@example kick user
#  ~kick @<userid>
#@example prune messages
#  ~prune <amount as number>
module Moderation
  extend Discordrb::Commands::CommandContainer

  command(:ban, required_permissions: [:ban_members], permission_message: 'You need permission to ban members first.', min_args: 2, max_args: 2, usage: 'please mention a user') do |event, mention, days = 0|
    if event.message.mentions.empty?
      event.respond 'Im sorry, but you need to mention the person you want to ban.'
      next
    end

    user = Bot.parse_mention(mention.to_s).id
    days = if days <= 0
             0
           elsif days.positive? && days <= 1
             1
           else
             7
           end
    begin
      event.server.ban(user.to_s, days)
    rescue Discordrb::Errors::NoPermission
      begin
        event.channel.send_embed do |embed|
          embed.title = 'I need permission to ban members first.'
          embed.colour = 'CE4629'
          embed.description = "I couldn't ban. Possible causes:\n1) I don't have ban members permission.\n2) That user has a role higher or equal to mine.\nPlease make sure both are fixed and try again, thanks."
        end
      rescue Discordrb::Errors::NoPermission
        event.respond "I couldn't ban. Possible causes:\n1) I don't have ban members permission.\n2) That user has a role higher or equal to mine.\nPlease make sure both are fixed and try again, thanks."
      end
      next
    end
    begin
      dis = Bot.user(user).distinct
      event.channel.send_embed do |embed|
        embed.title = 'Somebody order a ban hammer?'
        embed.colour = 0x7d5eba
        embed.description = "You just banned #{dis} and they can't rejoin until unbanned.\nHow much history got deleted? #{days} days..."

        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Beaner boi: #{dis}", icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png')
      end
    rescue Discordrb::Errors::NoPermission
      event.respond "<@#{user}> has been beaned, the past #{days} day(s) of messages from them have been deleted"
    end
  end

  command(:kick, required_permissions: [:kick_members], permission_message: 'Im sorry but you don\'t have the necessary permission of: `KICK MEMBERS`.', min_args: 1, max_args: 1, usage: 'please mention a user') do |event, mention|
    if event.message.mentions.empty?
      event.respond 'Im sorry, but you need to mention the person you want to kick.'
      next
    end

    user = Bot.parse_mention(mention.to_s).id

    begin
      event.server.kick(user.to_s)
    rescue Discordrb::Errors::NoPermission
      begin
        event.channel.send_embed do |embed|
          embed.title = 'In sorry, I cannot kick!'
          embed.colour = 'CE4629'
          embed.description = "I couldn't kick. Possible causes:\n1) I don't have kick members permission.\n2) That user has a role higher or equal to mine.\nPlease make sure both are fixed and try again, thanks."
        end
      rescue Discordrb::Errors::NoPermission
        event.respond "I couldn't kick. Possible causes:\n1) I don't have kick members permission.\n2) That user has a role higher or equal to mine.\nPlease make sure both are fixed and try again, thanks."
      end
      next
    end
    begin
      dis = Bot.user(user).distinct
      event.channel.send_embed do |embed|
        embed.title = 'Somebody order a kick cricket?'
        embed.colour = 0x7d5eba
        embed.description = "You just kicked #{dis} and they can't rejoin unless re-invited."

        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "Who did the kick? #{event.user.distinct}", icon_url: 'https://cdn.discordapp.com/embed/avatars/0.png')
      end
    rescue Discordrb::Errors::NoPermission
      event.respond "<@#{user}> has been kicked."
    end
  end

  command(:prune, min_args: 1, max_args: 1, required_permissions: [:manage_messages], permission_message: 'imma keep it real with u chief! You need permission to manage messages, come on bro we all do.') do |event, howmany|
    howmany = howmany.to_i
    begin
      event.message.delete
      event.channel.prune(howmany)
    rescue Discordrb::Errors::NoPermission
      event.respond "Im sorry, but I don't have the Manage Messages permission"
    end
    begin
      m = event.channel.send_embed do |embed|
        embed.title = 'Messages Successfully Pruned'
        embed.colour = 0xd084
        embed.description = ":wastebasket: Say goodbye to #{howmany} messages!"

        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'This message will automatically delete in 5 seconds.')
      end
      sleep 5
      m.delete
    rescue Discordrb::Errors::NoPermission
      event.send_temporary_message(":wastebasket: Say goodbye to #{howmany} messages!", 5)
    end
  end
end