module Botbckt #:nodoc:
  
  # This acts as a kind of abstract class for Botbckt commands. Subclass
  # this class to define new bot commands.
  #
  # Command subclasses must (re-)define call. If any setup is needed, override
  # create! and return self.instance.
  #
  class Command
    include Utilities
    include Singleton
    
    # By default, returns the singleton instance. Override in a subclass if
    # a different behavior is expected.
    #
    # ==== Parameters (args)
    # sender<String>:: The user and host of the triggering user. Example: botbckt!n=botbckt@unaffiliated/botbckt
    # channel<String>:: The channel on which the command was triggered. Example: #ruby-lang
    # *args:: Any string following the trigger in the message
    #
    def self.create!(*args)
      self.instance
    end

    # This method is executed by the Bot when a command is triggered. Override
    # it in a subclass to get the behavior you want.
    #
    # ==== Parameters (args)
    # sender<String>:: The user and host of the triggering user. Example: botbckt!n=botbckt@unaffiliated/botbckt
    # channel<String>:: The channel on which the command was triggered. Example: #ruby-lang
    # *args:: Any string following the trigger in the message
    #
    def call(*args)
      raise NoMethodError, "Implement #call in a subclass."
    end
    
    # Registers a new command with the bot.
    #
    # ==== Parameters
    # command<Symbol>:: In-channel trigger for the command. Required.
    # &block:: An optional block to execute, in lieu of call.
    #
    def self.trigger(command, &block)
      Botbckt::Bot.instance.register(command, block_given? ? block : self)
    end
    
    # ==== Parameters
    # msg<String>:: A message to send to the channel. Required.
    # channel<String>:: The channel to send the message. Required.
    #
    def self.say(msg, channel)
      Botbckt::Bot.instance.say(msg, channel) if msg
    end
    
    # Proxy for Command.say
    #
    def say(msg, channel)
      self.class.say(msg, channel)
    end
    
  end
  
end
