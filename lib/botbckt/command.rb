module Botbckt #:nodoc:
  
  # This acts as a kind of abstract class for Botbckt commands. Extend your
  # command class with this module to define new bot commands.
  #
  # Command subclasses must (re-)define initialize and call.
  #
  class Command

    # ==== Parameters (args)
    # sender<String>:: The user and host of the triggering user. Example: botbckt!n=botbckt@unaffiliated/botbckt
    # channel<String>:: The channel on which the command was triggered. Example: #ruby-lang
    # *args:: Any string following the trigger in the message
    #
    def initialize(*args)
      raise NoMethodError, "Implement #initialize in a subclass."
    end

    # ==== Parameters (args)
    # sender<String>:: The user and host of the triggering user. Example: botbckt!n=botbckt@unaffiliated/botbckt
    # channel<String>:: The channel on which the command was triggered. Example: #ruby-lang
    # *args:: Any string following the trigger in the message
    #
    def call(*args)
      raise NoMethodError, "Implement #initialize in a subclass."
    end
    
    # Registers a new command with the bot.
    #
    # ==== Parameters
    # command<Symbol>:: In-channel trigger for the command. Required.
    #
    def self.trigger(command)
      Botbckt::Bot.commands[command.to_sym] = self
    end
    
    # ==== Parameters
    # msg<String>:: A message to send to the channel. Required.
    # channel<String>:: The channel to send the message. Required.
    #
    def say(msg, channel)
      Botbckt::Bot.say(msg, channel) if msg
    end
    
  end
  
end
