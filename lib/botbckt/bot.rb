module Botbckt #:nodoc:
  
  # Create a new IRC bot. See Bot.start to get started.
  #
  class Bot
    include Singleton
    include ActiveSupport::BufferedLogger::Severity
    
    AFFIRMATIVE = ["'Sea, mhuise.", "In Ordnung", "Ik begrijp", "Alles klar", "Ok.", "Roger.", "You don't have to tell me twice.", "Ack. Ack.", "C'est bon!"]
    NEGATIVE    = ["Titim gan éirí ort.", "Gabh mo leithscéal?", "No entiendo", "excusez-moi", "Excuse me?", "Huh?", "I don't understand.", "Pardon?", "It's greek to me."]

    attr_accessor :logger
    attr_accessor :store
    attr_accessor :connection
    
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
    # :log_level<Integer>:: The minimum severity level to log. Defaults to 1 (INFO).
    # :pid<String>:: The name of a file to drop the PID. Defaults to 'botbckt.pid'.
    # :daemonize<Boolean>:: Fork and background the process. Defaults to true.
    # :backend_host<String>:: The hostname of a Redis store. Optional.
    # :backend_port<Integer>:: The port used by the Redis store. Optional.
    #
    def self.start(options)
      daemonize = options.delete(:daemonize)
      pid = options.delete(:pid) || 'botbckt.pid'

      if daemonize || daemonize.nil?
        EventMachine::fork_reactor do
          start!
          
          if pid
            File.open(pid, 'w') { |file| file.write("#{Process.pid}") }
            at_exit { File.delete(pid) if File.exist?(pid) }
          end
          
        end
      else
        EventMachine::run { start! }
      end
    end
    
    # Registers a new command.
    #
    # ==== Parameters
    # command<~to_sym>:: Trigger to register. Required.
    # callable<~call>:: Callback or class with #call to execute. Required.
    #
    def register(command, callable)
      @commands ||= { }
      @commands[command.to_sym] = callable
    end

    # Returns currently registered commands.
    #
    def commands
      @commands
    end
    
    # Sets the key to the given value, creating the key if necessary.
    #
    # ==== Parameters
    # key<String>:: The identifier for this value. Required.
    # value<Object>:: The value to store at the key. Required.
    # &block:: A callback to execute after the value is stored. The block should
    #          take a single parameter: the value stored. Optional.
    #
    #--
    # TODO: Forwardable?
    #++
    def set(key, value, &block)
      self.store && self.store.set(key, value, &block)
    end
    
    # Retrieves the value stored at key. Returns nil if the key does not exist.
    #
    # ==== Parameters
    # key<String>:: The identifier to retrieve. Required.
    # &block:: A callback to execute after the value is retrieved. The block should
    #          take a single parameter: the value retrieved. Required.
    #
    #--
    # TODO: Forwardable?
    #++
    def get(key, &block)
      self.store && self.store.get(key, &block)
    end
    
    # Increments the value stored at key by 1, creating the key and initializing
    # it to 0 if necessary.
    #
    # ==== Parameters
    # key<String>:: The identifier whose value should be incremented. Required.
    # &block:: A callback to execute after the value is stored. The block should
    #          take a single parameter: the value stored. Optional.
    #
    #--
    # TODO: Forwardable?
    #++
    def increment!(key, &block)
      self.store && self.store.increment!(key, &block)
    end

    # ==== Parameters
    # command<Symbol>:: The name of a registered command to run. Required.
    # sender<String>:: The sender (incl. hostmask) of the trigger. Required.
    # channel<String>:: The channel on which the command was triggered. Required.
    # *args:: Arguments to be passed to the command. Optional.
    #
    #--
    # TODO: Before/after callbacks?
    #++
    def run(command, sender, channel, *args)
      callable = commands[command.to_sym] || raise("Unregistered command called. (#{command})")
      
      if callable.is_a?(Class)
        # Callables are Singletons; we use #create! as a convention to give
        # possible setup code a place to live. 
        callable = callable.create!(sender, channel, *args)
      end
      
      if callable.respond_to?(:call)
        callable.call(sender, channel, *args)
      else
        raise("Non-callable used as command. (#{command})")
      end

    rescue StandardError => error
      log "ERROR:\n#{error.inspect}\n#{error.backtrace}", DEBUG
      say Bot.befuddled, channel
    end
    
    # Returns a random "affirmative" message. Use to acknowledge user input.
    #
    #--
    # Inspired by Clojurebot: http://github.com/hiredman/clojurebot
    #++
    def self.ok
      AFFIRMATIVE[rand(AFFIRMATIVE.size)]
    end
    
    # Returns a random "confused" message. Use as a kind of "method missing"
    # on unknown user input.
    #
    #--
    # Inspired by Clojurebot: http://github.com/hiredman/clojurebot
    #++
    def self.befuddled
      NEGATIVE[rand(NEGATIVE.size)]
    end
    
    # ==== Parameters
    # msg<String>:: A message to send to the channel. Required.
    # channel<String>:: The channel to send the message. Required.
    #
    def say(msg, channel)
      self.connection.say msg, channel
    end

    # ==== Parameters
    # msg<String>:: A message to log. Required.
    # level<Integer>:: The minimum log level at which to log this message. Defaults to INFO.
    #
    def log(msg, level = INFO)
      self.logger.add(level, msg)
    end
    
    private
    
    def self.start!(options) #:nodoc:
      self.instance.logger = ActiveSupport::BufferedLogger.new options.delete(:log) || 'botbckt.log',
                                                               options.delete(:log_level) || INFO
                                                               
      host, port = options.delete(:backend_host), options.delete(:backend_port)
      
      if host && port
        self.instance.store = Store.new(host, port)
      end
      
      self.instance.connection = Botbckt::IRC.connect(options.merge(:bot => self.instance))   
    end
    
  end

end
