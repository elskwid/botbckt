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
      
      log = config[:log] || 'botbckt.log'
      @logger = ActiveSupport::BufferedLogger.new(log)
    end
    
    #--
    # TODO: Handle multiple channels
    #++
    def say(msg)
      msg.split("\n").each do |msg|
        command "PRIVMSG", "##{config.channels.first}", ":#{msg}"
      end
    end
    
    # callbacks
    def post_init
      command "USER", [config.user]*4
      command "NICK", config.user
      command("NickServ IDENTIFY", config.user, config.password) if config.password
      config.channels.each { |channel| command("JOIN", "##{ channel }")  } if config.channels
    end

    #--
    # FIXME: Re-order commands args such that 1-2 arity commands can still access
    #        both sender and channel
    #++
    def receive_line(line)
      case line
      when /^PING (.*)/:
        command('PONG', $1)
      when /^:(\S+) PRIVMSG (.*) :(~|#{Regexp.escape config.user}: )(\w+)( .*)?$/:
        # args are optional - not all commands need/support them
        args = $5 ? [$5.squish, $1, $2] : [$1, $2]
        
         # run args: command (with args), sender, channel
        Botbckt::Bot.run($4, *args)
      else
        log line
      end
    end

    def unbind
      EM.add_timer(3) do
        reconnect(config.server, config.port)
        post_init
      end
    end
    
    private
    
    #--
    # TODO: Add log levels
    #++
    def log(msg)
      @logger.add(0, msg)
    end
    
    def command(*cmd)
      line = "#{ cmd.flatten.join(' ') }\r\n"
      send_data line
      log line
    end
    
  end
  
end
