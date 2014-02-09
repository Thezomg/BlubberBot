require 'cinch'
require 'sequel'

class Tell
    include Cinch::Plugin

    listen_to :message
    match /tell (\S+) (.+)/

    def listen(m)
        channel = ""
        if m.channel
            channel = m.channel.name.downcase
        end
        msg = @msgs.grep(:nick, m.user.nick ,:case_insensitive=>true)

        to_send_priv = Array.new
        to_send_pub = Array.new

        msg.all.each do |mess|
            if mess[:channel] == "pm" or mess[:channel] != channel
                to_send_priv.push "#{mess[:channel]} <#{mess[:sender]}> #{mess[:message]}"
            else
                to_send = "#{mess[:nick]}\: \<#{mess[:sender]}\> #{mess[:message]}"

                if not m.channel
                    to_send = "#{mess[:channel]} #{to_send}"
                end
                to_send_pub.push to_send
            end
        end

        to_send_priv.each do |mess|
            m.user.msg(mess)
        end

        to_send_pub.each do |mess|
            m.reply(mess)
        end

        msg.delete
    end

    def execute(m, nick, message)
        channel = "pm"
        if m.channel
            channel = m.channel.name.downcase
        end

        @msgs.insert(:nick => nick, :message => message, :sender => m.user.nick, :channel => channel, :time => DateTime.now)
        m.reply("#{m.user.nick}, I will tell #{nick} that.")
    end

    def initialize(*args)
        super
        @db = Sequel.connect('sqlite://dbs/database.db')
        @db.create_table? :messages do
            primary_key :id
            String :nick
            String :sender
            String :message
            String :channel
            DateTime :time
        end
        @msgs = @db.from(:messages)
    end

end