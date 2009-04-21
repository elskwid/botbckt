module Botbckt
  
  class Remind
    extend Commands

    SCALES = %w{ minute minutes second seconds hour hours }

    on :remind do |reminder_string, user, *args|
      _, num, scale, msg = */in (\d+) (\w+) with (.*)/i.match(reminder_string)
      
      if SCALES.include?(scale)
      	time = num.to_i.send(scale.to_sym).seconds

        # TODO: Abstraction here, please.
      	remind(user.gsub(/([^!]+).*/, '\1'), msg, time)
      else 
        say Botbckt::Bot.befuddled
      end
    end
    
    private
    
    def self.remind(user, msg, seconds)
      EventMachine::Timer.new(seconds) do
        say "#{user}: #{msg}"
      end
      say Botbckt::Bot.ok
    end
    
  end
  
end
