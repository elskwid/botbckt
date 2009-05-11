module Botbckt #:nodoc:
  
  # Create a new IRC bot. See Bot.start to get started.
  #
  class Bot
    include Singleton
    include ActiveSupport::BufferedLogger::Severity
    
    AFFIRMATIVE = ["'Sea, mhuise.", "In Ordnung", "Ik begrijp", "Alles klar", "Ok.", "Roger.", "You don't have to tell me twice.", "Ack. Ack.", "C'est bon!"]
    NEGATIVE    = ["Titim gan éirí ort.", "Gabh mo leithscéal?", "No entiendo", "excusez-moi", "Excuse me?", "Huh?", "I don't understand.", "Pardon?", "It's greek to me."]

    attr_accessor :logger
    
    cattr_accessor :commands
    cattr_accessor :store
    @@commands = { }
    @@store = nil
    
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

      self.instance.logger = ActiveSupport::BufferedLogger.new options.delete(:log) || 'botbckt.log',
                                                               options.delete(:log_level) || INFO
                                                               
      host, port = options.delete(:backend_host), options.delete(:backend_port)
      daemonize = options.delete(:daemonize)
      pid = options.delete(:pid) || 'botbckt.pid'

      if daemonize || daemonize.nil?
        EventMachine::fork_reactor do
          Botbckt::IRC.connect(options)
          
          if host && port
             self.store = Store.new(host, port)
           end
          
          if pid
            File.open(pid, 'w'){ |f| f.write("#{Process.pid}") }
            at_exit { File.delete(pid) if File.exist?(pid) }
          end
          
        end
      else
        EventMachine::run do
          Botbckt::IRC.connect(options)
        end
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
    
    #--
    # TODO: Forwardable?
    #++
    def self.set(key, value)
      self.store && self.store.set(key, value)
    end
    
    #--
    # TODO: Forwardable?
    #++
    def self.get(key)
      self.store && self.store.get(key)
    end
    
    #--
    # TODO: Forwardable?
    #++
    def self.increment!(key)
      self.store && self.store.increment!(key)
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
      callable = commands[command.to_sym]
      
      if callable.is_a?(Class)
        # Callables are Singletons; we use #create! as a convention to give
        # possible setup code a place to live. 
        callable = callable.create!(sender, channel, *args)
      end
      
      callable.respond_to?(:call) ? callable.call(sender, channel, *args) : say(Bot.befuddled, channel)
    # TODO: Log me.
    rescue StandardError => e
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
    # msg<String>:: A message to send to the channel
    # channel<String>:: The channel to send the message. Required.
    #
    def say(msg, channel)
      Botbckt::IRC.connection.say msg, channel
    end

    def log(msg, level = INFO) #:nodoc:
      self.logger.add(level, msg)
    end
    
  end

end
