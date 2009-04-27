module Botbckt #:nodoc:
  
  # An EventMachine-based IRC client. See IRC.connect to get started.
  #
  class IRC < EventMachine::Connection
    include EventMachine::Protocols::LineText2
    
    attr_accessor :config
    cattr_accessor :connection
    
    # Instantiate a new IRC connection.
    #
    # ==== Parameters
    # options<Hash{Symbol => String,Integer}>
    #
    # ==== Options (options)
    # :user<String>:: The username this instance should use. Required.
    # :password<String>:: A password to send to the Nickserv. Optional.
    # :server<String>:: The FQDN of the IRC server. Required.
    # :port<~to_i>:: The port number of the IRC server. Required.
    # :channels<Array[String]>:: An array of channels to join. Channel names should *not* include the '#' prefix. Required.
    # :log<String>:: The name of a log file. Defaults to 'botbckt.log'.
    #
    def self.connect(options)
      self.connection = EM.connect(options[:server], options[:port].to_i, self, options)
    end
    
    # Use IRC.connect; this method is not for you.
    #
    def initialize(options) #:nodoc:
      self.config = OpenStruct.new(options)
      
      log = config[:log] || 'botbckt.log'
      @logger = ActiveSupport::BufferedLogger.new(log)
    end
    
    # ==== Parameters
    # msg<String>:: A message to send to the channel
    #
    #--
    # TODO: Handle multiple channels
    #++
    def say(msg)
      msg.split("\n").each do |msg|
        command "PRIVMSG", "##{config.channels.first}", ":#{msg}"
      end
    end
    
    
    def post_init #:nodoc:
      command "USER", [config.user]*4
      command "NICK", config.user
      command("NickServ IDENTIFY", config.user, config.password) if config.password
      config.channels.each { |channel| command("JOIN", "##{ channel }")  } if config.channels
    end

    #--
    # FIXME: Re-order commands args such that 1-2 arity commands can still access
    #        both sender and channel
    #++
    def receive_line(line) #:nodoc:
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

    def unbind #:nodoc:
      EM.add_timer(3) do
        reconnect(config.server, config.port)
        post_init
      end
    end
    
    private
    
    #--
    # TODO: Add log levels
    #++
    def log(msg) #:nodoc:
      @logger.add(0, msg)
    end
    
    def command(*cmd) #:nodoc:
      line = "#{ cmd.flatten.join(' ') }\r\n"
      send_data line
      log line
    end
    
  end
  
end
