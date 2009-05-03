module Botbckt #:nodoc:

  # Returns 'PONG!' in-channel
  #
  class Ping < Command
    
    trigger :ping
    
    def initialize; end #:nodoc:
    
    def call(sender, channel, *args)
      say 'PONG!', channel
    end
  end
  
end