module Botbckt
  
  class Meme
    extend Commands
    
    on :meme do |*args|
      say meme
    end
   
   private
   
   def self.meme
     open("http://meme.boxofjunk.ws/moar.txt?lines=1").read.chomp
   end
    
  end
  
end