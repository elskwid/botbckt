module Botbckt #:nodoc:

  # Returns 'PONG!' in-channel
  #
  class Ping
    extend Botbckt::Commands
    
    on :ping do |sender, channel, *args|
      say 'PONG!', channel
    end
  end
  
end