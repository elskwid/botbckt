module Botbckt #:nodoc:

  # Returns 'PONG!' in-channel
  #
  class Ping
    extend Commands
    
    on :ping do |*args|
      say 'PONG!'
    end
  end
  
end