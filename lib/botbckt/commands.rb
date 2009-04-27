module Botbckt
  
  module Commands
    
    #--
    # Inspired by Isaac: http://github.com/ichverstehe/isaac
    #++
    def on(command, &block)
      Botbckt::Bot.commands[command] = block
    end
    
    def say(msg)
      Botbckt::Bot.say msg
    end
    
  end
  
end

Dir[File.dirname(__FILE__) + '/commands/*'].each { |lib| require lib }