module Botbckt #:nodoc:
  
  # Create a new IRC bot. See Bot.start to get started.
  #
  class Bot
    
    AFFIRMATIVE = ["'Sea, mhuise.", "In Ordnung", "Ik begrijp", "Alles klar", "Ok.", "Roger.", "You don't have to tell me twice.", "Ack. Ack.", "C'est bon!"]
    NEGATIVE    = ["Titim gan éirí ort.", "Gabh mo leithscéal?", "No entiendo", "excusez-moi", "Excuse me?", "Huh?", "I don't understand.", "Pardon?", "It's greek to me."]
    
    cattr_accessor :commands
    @@commands = { }
    
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
    #
    def self.start(options)
      EventMachine::run do
        Botbckt::IRC.connect(options)
      end
    end
    
    # ==== Parameters
    # command<Symbol>:: The name of a registered command to run. Required.
    # *args:: Arguments to be passed to the command. Optional.
    #
    #--
    # TODO: Before/after callbacks?
    #++
    def self.run(command, *args)
      proc = self.commands[command.to_sym]
      proc ? proc.call(*args) : say(befuddled)
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
    #
    def self.say(msg)
      Botbckt::IRC.connection.say msg
    end
    
  end

end