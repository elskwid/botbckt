module Botbckt #:nodoc:
  
  # Gives a gold star to a space-separated list of users.
  #
  #  < user> ~star joe
  #  < botbckt> joe: Gold star for you!
  #
  # But when a user tries to award himself...
  #
  #  < user> ~star user
  #  < botbckt> user: No star for you!
  #
  class StarJar < Command
   
    trigger :star
   
    def call(giver, channel, receiver)
      receiver.split(' ').each do |rcv|
        if rcv != freenode_split(giver).first
          say "#{rcv}: Gold star for you!", channel
        else
          say "#{rcv}: No star for you!", channel
        end
      end
    end
    
  end
  
end