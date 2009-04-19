module Botbckt
  
  class Snack
    extend Commands
    
    on :botsnack do |*args|
      say 'nom nom nom'
    end
    
  end
  
end