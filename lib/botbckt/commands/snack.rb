module Botbckt #:nodoc:
  
  # Feeds the bot a tasty treat.
  #
  # Inspired by Clojurebot: http://github.com/hiredman/clojurebot
  #
  class Snack < Command
    
    trigger :botsnack

    def call(sender, channel, *args)
      say 'nom nom nom', channel
    end
    
  end
  
end