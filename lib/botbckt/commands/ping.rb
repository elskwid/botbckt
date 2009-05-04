module Botbckt #:nodoc:

  # Returns 'PONG!' in-channel
  #
  class Ping < Command
    
    trigger :ping

    def call(sender, channel, *args)
      say 'PONG!', channel
    end
  end
  
end