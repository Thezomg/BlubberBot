require 'cinch'
require 'yaml'
require 'sequel'

module Cinch
    module ConfPlugin
        include Cinch::Plugin
        def initialize(*args)
            begin
                @conf = YAML.load_file("config/#{self.class}.yaml")
            rescue
                @conf = {}
            end
            super *args
        end

        def save_config()
            if not Dir.exists?('config')
                Dir.mkdir('config')
            end
            File.open("config/#{self.class}.yaml", 'w') { |fo| fo.puts @conf.to_yaml }
        end

        def get_db()
            if not Dir.exists?('dbs')
                Dir.mkdir('dbs')
            end
            Sequel.connect("sqlite://dbs/#{self.class}.db")
        end
    end
end