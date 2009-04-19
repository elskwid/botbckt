module Botbckt
  
  module Commands
    
    def on(command, &block)
      Botbckt::Bot.commands[command] = block
    end
    
    def say(msg)
      Botbckt::IRC.connection.say msg
    end
    
  end
  
end

Dir[File.dirname(__FILE__) + '/commands/*'].each { |lib| require lib }