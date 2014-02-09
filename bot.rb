require 'cinch'
require './plugins/tell.rb'
require 'yaml'

bot = Cinch::Bot.new do
    configure do |c|
        begin
            conf = YAML.load_file('config.yaml')
            c.load(conf)
        rescue
            ## Default config
            c.nick = 'BlubberBot'
            c.server = 'irc.gamesurge.net'
            c.channels = ['#llama5']
            #c.verbose = true
            c.plugins.plugins = [Tell]
            File.open('config.yaml', 'w') { |fo| fo.puts c.to_h.to_yaml }
            abort("Config doesn't exist, creating config.yaml")
        end
    end
end

bot.start
