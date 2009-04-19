module Botbckt
  
  class Bot
    
    cattr_accessor :commands
    @@commands = { }
    
    def self.start(options)
      EventMachine::run do
        Botbckt::IRC.connect(options)
      end
    end
    
    def self.run(command, *args)
      proc = self.commands[command.to_sym]
      proc ? proc.call(*args) : nil
    end
    
  end

end