module Botbckt
  
  class Bot
    
    AFFIRMATIVE = ["'Sea, mhuise.", "In Ordnung", "Ik begrijp", "Alles klar", "Ok.", "Roger.", "You don't have to tell me twice.", "Ack. Ack.", "C'est bon!"]
    NEGATIVE    = ["Titim gan éirí ort.", "Gabh mo leithscéal?", "No entiendo", "excusez-moi", "Excuse me?", "Huh?", "I don't understand.", "Pardon?", "It's greek to me."]
    
    cattr_accessor :commands
    @@commands = { }
    
    def self.start(options)
      EventMachine::run do
        Botbckt::IRC.connect(options)
      end
    end
    
    #--
    # TODO: Before/after callbacks?
    #++
    def self.run(command, *args)
      proc = self.commands[command.to_sym]
      proc ? proc.call(*args) : say(befuddled)
    end
    
    #--
    # Inspired by Clojurebot: http://github.com/hiredman/clojurebot
    #++
    def self.ok
      AFFIRMATIVE[rand(AFFIRMATIVE.size)]
    end
    
    #--
    # Inspired by Clojurebot: http://github.com/hiredman/clojurebot
    #++
    def self.befuddled
      NEGATIVE[rand(NEGATIVE.size)]
    end
    
    def self.say(msg)
      Botbckt::IRC.connection.say msg
    end
    
  end

end