module Botbckt #:nodoc:

  # Schedules a reminder for a period of seconds, minutes or hours to be
  # repeated in-channel:
  #
  #  < user> ~remind in 5 minutes with message
  #  ... five minutes
  #  < botbckt> user: message
  #
  class Remind < Command

    SCALES = %w{ minute minutes second seconds hour hours }

    trigger :remind
    
    def call(user, channel, reminder_string)
      # Somewhat faster than #match...
      reminder_string =~ /in (\d+) (\w+) with (.*)/i
      num, scale, msg = $1, $2, $3
      
      if SCALES.include?(scale)
      	time = num.to_i.send(scale.to_sym).seconds

      	remind(freenode_split(user).first, channel, msg, time)
      else 
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    private
    
    def remind(user, channel, msg, seconds) #:nodoc:
      EventMachine::Timer.new(seconds) do
        say "#{user}: #{msg}", channel
      end
      say Botbckt::Bot.ok, channel
    end
    
  end
  
end
