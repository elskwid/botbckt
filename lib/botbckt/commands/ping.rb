module Botbckt #:nodoc:

  # Returns 'PONG!' in-channel
  #
  class Ping
    extend Commands
    
    on :ping do |sender, channel, *args|
      say 'PONG!', channel
    end
  end
  
end