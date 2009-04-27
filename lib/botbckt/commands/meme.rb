module Botbckt
  
  # Grabs the first boxofjunk meme and returns output in-channel:
  #
  # < user> ~meme
  # < botbckt> THIS IS LARGE. I CAN TELL BY THE DRINKS, AND FROM HAVING SEEN A LOT OF DRAGONS IN MY DAY.
  #
  class Meme
    extend Commands
    
    on :meme do |*args|
      say meme
    end
   
   private
   
   def self.meme #:nodoc:
     open("http://meme.boxofjunk.ws/moar.txt?lines=1").read.chomp
   end
    
  end
  
end