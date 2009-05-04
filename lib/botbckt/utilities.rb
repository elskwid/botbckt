module Botbckt #:nodoc:
  
  module Utilities
   
    # Splits a Freenode user string into a login, user, hostmask tuple
    #
    # ==== Parameters
    # str<String>:: The user string to split
    #
    def freenode_split(str)
      str.scan(/^([^!]+)!n=([^@]+)@(.*)$/).flatten!
    end
    
  end
  
end