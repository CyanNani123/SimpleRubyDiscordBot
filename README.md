# SimpleRubyDiscordBot

A simple Discord bot using discordrb.

## Quick Guide

1. Install the necessary gems with bundler: `bundle install`
2. Create a bot app at the Discord dev portal to get a token and client_id
3. Create a config file (see underneath for more details).
4. Run with `ruby src/main.rb`

## Build Documentation

1. Install yard with `gem install yard`
2. Build the doc with `yard doc`

## Create a configuration file

1. Create a file called config.json.
2. In the config.json create an object as following

```
{
  "token": "<bot token>",
  "client_id": <bot id>,
  "prefix": "<prefix e.g. ~>",
  "owner_id": <your user id>
}
```