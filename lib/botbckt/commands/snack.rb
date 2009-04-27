module Botbckt #:nodoc:
  
  # Feeds the bot a tasty treat.
  #
  # Inspired by Clojurebot: http://github.com/hiredman/clojurebot
  #
  class Snack
    extend Commands
    
    on :botsnack do |*args|
      say 'nom nom nom'
    end
    
  end
  
end