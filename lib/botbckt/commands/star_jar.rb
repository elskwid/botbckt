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
   
    # Adds a star to the jar for the user
    #
    # ==== Parameters
    # user<String>:: The user receiving a star. Required.
    #
    def push(user)
      increment! "starjar-#{user}"
    end
    
    # Removes a star from the jar for the user
    #
    # ==== Parameters
    # user<String>:: The user being docked a star. Required.
    #
    def pop(user)
      stars = get "starjar-#{user}"
      
      if stars
        set "starjar-#{user}", stars - 1
      else
        set "starjar-#{user}", 0
      end
    end
   
    def call(giver, channel, receiver)
      receiver.split(' ').each do |rcv|
        if rcv != freenode_split(giver).first
          total = push(rcv)
          say "#{rcv}: Gold star for you! (#{total})", channel
        else
          say "#{rcv}: No star for you!", channel
        end
      end
    end
    
  end
  
end