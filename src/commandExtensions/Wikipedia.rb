# @example search an wiki entry and get the summary of it
#  ~wiki <string you want to search>
module Wikipedia
  extend Discordrb::Commands::CommandContainer

  command(:wiki, min_args: 1) do |event, *args|
    page = Wikipedia.find(args.join(''))
    event.respond("```#{page.summary}```")
  end
end
