module Botbckt #:nodoc:
  
  # Grabs the first boxofjunk meme and returns output in-channel:
  #
  #  < user> ~meme
  #  < botbckt> THIS IS LARGE. I CAN TELL BY THE DRINKS, AND FROM HAVING SEEN A LOT OF DRAGONS IN MY DAY.
  #
  class Meme < Command
    
    trigger :meme

    def call(sender, channel, *args)
      say meme, channel
    end
   
   private
   
   def meme #:nodoc:
     open("http://meme.boxofjunk.ws/moar.txt?lines=1").read.chomp
   end
    
  end
  
end