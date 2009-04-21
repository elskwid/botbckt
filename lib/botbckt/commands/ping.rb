module Botbckt
  
  class Ping
    extend Commands
    
    on :ping do |*args|
      say 'PONG!'
    end
  end
  
end