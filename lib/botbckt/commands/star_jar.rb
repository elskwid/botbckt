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

    attr_accessor :jar

    def self.create!(*args) #:nodoc:
      self.instance.jar ||= { }
      self.instance
    end
   
    # Adds a star to the jar for the user
    #
    # ==== Parameters
    # user<String>:: The user receiving a star. Required.
    #
    def push(user)
      @jar[user] ||= 0
      @jar[user] += 1
    end
    
    # Removes a star from the jar for the user
    #
    # ==== Parameters
    # user<String>:: The user being docked a star. Required.
    #
    def pop(user)
      @jar[user] ||= 0
      
      if @jar[user] == 0
        return 0
      else
        @jar[user] -= 1
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