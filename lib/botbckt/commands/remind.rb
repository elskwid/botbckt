module Botbckt

  # Schedules a reminder for a period of seconds, minutes or hours to be
  # repeated in-channel:
  #
  # < user> ~remind in 5 minutes with message
  # ... five minutes
  # < botbckt> user: message
  #
  class Remind
    extend Commands

    SCALES = %w{ minute minutes second seconds hour hours }

    on :remind do |reminder_string, user, *args|
      # Somewhat faster than #match...
      reminder_string =~ /in (\d+) (\w+) with (.*)/i
      num, scale, msg = $1, $2, $3
      
      if SCALES.include?(scale)
      	time = num.to_i.send(scale.to_sym).seconds

        # TODO: Abstraction here, please.
      	remind(user.gsub(/([^!]+).*/, '\1'), msg, time)
      else 
        say Botbckt::Bot.befuddled
      end
    end
    
    private
    
    def self.remind(user, msg, seconds) #:nodoc:
      EventMachine::Timer.new(seconds) do
        say "#{user}: #{msg}"
      end
      say Botbckt::Bot.ok
    end
    
  end
  
end
