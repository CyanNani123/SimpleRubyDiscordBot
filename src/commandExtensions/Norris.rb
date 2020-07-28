# @example post a chuck norris joke
#  ~norris
module Norris
  extend Discordrb::Commands::CommandContainer

  command(:norris, max_args: 0) do |event|
    url = URI.parse('http://api.icndb.com/jokes/random')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    norris_joke = JSON.parse(res.body)['value']['joke']
    event.respond(norris_joke)
  end
end
