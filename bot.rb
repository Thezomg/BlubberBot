require 'cinch'
require './plugins/tell.rb'

bot = Cinch::Bot.new do
    configure do |c|
        c.nick = 'BlubberBot'
        c.server = 'irc.gamesurge.net'
        c.channels = ['#llama5']
        # c.verbose = true
        c.plugins.plugins = [Tell]
    end
end

bot.start
