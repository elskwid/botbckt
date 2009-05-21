module Botbckt #:nodoc:

  # Schedules a reminder for a period of seconds, minutes or hours to be
  # repeated in-channel:
  #
  #  < user> ~remind in 5 minutes with message
  #  ... five minutes
  #  < botbckt> user: message
  #
  #  < user> ~remind at 10:30 with message
  #  ... at 10:30
  #  < botbckt> user: message
  #
  class Remind < Command

    SCALES = %w{ minute minutes second seconds hour hours }

    trigger :remind
    
    def call(user, channel, reminder_string)
      
      case reminder_string 
      when /^in/i
        msg, time = *relative_reminder(reminder_string)
      when /^at/i
        msg, time = *absolute_reminder(reminder_string)
      else
        say Botbckt::Bot.befuddled, channel
        return
      end
      
      if msg && time
        remind(freenode_split(user).first, channel, msg, time)
      else
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    private

    def relative_reminder(str) #:nodoc:
      # Somewhat faster than #match...
      str =~ /in (\d+) (\w+) with (.*)/i
      num, scale, msg = $1, $2, $3
      
      if SCALES.include?(scale)
      	time = num.to_i.send(scale.to_sym).seconds
        [ msg, time ]
      else 
        [ ]
      end
    end
    
    def absolute_reminder(str) #:nodoc:
      # Somewhat faster than #match...
      str =~ /at (.*) with (.*)/i
      time, msg = $1, $2
      
      time = Time.parse(time) - Time.now
      
      [ msg, time ]
    # TODO: Log me.
    rescue ArgumentError => e
      # raised by Time.parse; do nothing, for now...
      [ ]
    end
    
    def remind(user, channel, msg, seconds) #:nodoc:
      EventMachine::Timer.new(seconds) do
        say "#{user}: #{msg}", channel
      end
      say Botbckt::Bot.ok, channel
    end
    
  end
  
end
