module Botbckt
  
  class IRC < EventMachine::Connection
    include EventMachine::Protocols::LineText2
    
    attr_accessor :config
    cattr_accessor :connection
    
    def self.connect(options)
      self.connection = EM.connect(options[:server], options[:port].to_i, self, options)
    end
    
    def initialize(options)
      self.config = OpenStruct.new(options)
    end
    
    def say(msg)
      msg.split("\n").each do |msg|
        command "PRIVMSG", "##{config.channels.first}:", msg
      end
    end
    
    # callbacks
    def post_init
      command "USER", [config.user]*4
      command "NICK", config.user
      command("NickServ IDENTIFY", config.user, config.password) if config.password
      config.channels.each { |channel| command("JOIN", "##{ channel }")  } if config.channels
    end

    def receive_line(line)
      case line
      when /^PING (.*)/ : command('PONG', $1)
      when /^:(\S+) PRIVMSG (.*) :~(\w+)( .*)?$/:
        args = $4 ? [$4.squish, $1, $2] : [$1, $2]
        Botbckt::Bot.run($3, *args) # args: command (with args), sender, channel
        
      when /^:\S* \d* #{ config.user } @ #{ '#' + config.channels.first } :(.*)/ : dequeue($1)
      else puts line; end
    end

    def unbind
      EM.add_timer(3) do
        reconnect(config.server, config.port)
        post_init
      end
    end
    
    private
    
    def command(*cmd)
      send_data "#{ cmd.flatten.join(' ') }\r\n"
    end
    
  end
  
end