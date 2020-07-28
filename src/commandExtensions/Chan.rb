# @example displays newest post on 4chan
#  ~channew <boardname>
# @example displays random post on 4chan
#  ~chanrandom <boardname>
module Chan
  extend Discordrb::Commands::CommandContainer

  command(:channew, min_args: 1, max_args: 1) do |event, *args|
    board = args.join('')
    url = URI.parse("http://a.4cdn.org/#{board}/1.json")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    site = JSON.parse(res.body)
    thread_amount = site['threads'].length
    sticky_amount = 0
    (0..thread_amount - 1).each do |i|
      sticky_amount += site['threads'][i]['posts'][0]['sticky'].to_i
    end
    thread = site['threads'][sticky_amount]
    comment_amount = thread['posts'].length
    # comment, attributes: "no","now","name","com"
    c = thread['posts'][comment_amount - 1]
    c['com'] = ReverseMarkdown.convert CGI.unescapeHTML((c['com']))
    event.channel.send_embed do |e|
      e.title = "Newest comment of #{board}"
      e.add_field(name: 'No', value: c['no'], inline: true)
      e.add_field(name: 'Time', value: c['now'], inline: true)
      e.add_field(name: 'User', value: c['name'], inline: true)
      e.add_field(name: 'Comment', value: c['com'], inline: true)
    end
  end

  command(:chanrandom, min_args: 1, max_args: 1) do |event, *args|
    board = args.join('')
    url = URI.parse("http://a.4cdn.org/#{board}/1.json")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    site = JSON.parse(res.body)
    thread_amount = site['threads'].length
    sticky_amount = 0
    (0..thread_amount - 1).each do |i|
      sticky_amount += site['threads'][i]['posts'][0]['sticky'].to_i
    end
    random_thread = site['threads'][Random.rand(thread_amount - sticky_amount) + sticky_amount]
    comment_amount = random_thread['posts'].length
    # random comment, attributes: "no","now","name","com"
    rc = random_thread['posts'][Random.rand(comment_amount)]
    rc['com'] = ReverseMarkdown.convert CGI.unescapeHTML((rc['com']))
    event.channel.send_embed do |e|
      e.title = "Random comment of #{board}"
      e.add_field(name: 'No', value: rc['no'], inline: true)
      e.add_field(name: 'Time', value: rc['now'], inline: true)
      e.add_field(name: 'User', value: rc['name'], inline: true)
      e.add_field(name: 'Comment', value: rc['com'], inline: true)
    end
  end
end
