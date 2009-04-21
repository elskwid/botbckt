module Botbckt
  
  class Remind
    extend Commands

    on :remind do |reminder_string, user, *args|
      _, num, scale, msg = /in (\d+) (\w+) with (.*)/i.match(reminder_string)
      
      begin
        time = num.to_i.send(scale.to_sym).seconds
        remind(user, msg, time)
      rescue NoMethodError => e
        puts "OOPS: #{e.message}"
        Botbckt::Bot.befuddled
      end
    end
    
    private
    
    def self.remind(user, msg, seconds)
      EventMachine::Timer.new(seconds) do
        say "#{user}: #{msg}"
      end
      Botbckt::Bot.ok
    end
    
  end
  
end