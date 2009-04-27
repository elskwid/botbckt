module Botbckt #:nodoc:
  
  # This acts as a kind of abstract class for Botbckt commands. Extend your
  # command class with this module to define new bot commands.
  #
  module Commands
    
    # Registers a new command with the bot. Either a proc or a block are
    # required.
    #
    # Inspired by Isaac: http://github.com/ichverstehe/isaac
    #
    # ==== Parameters
    # command<Symbol>:: In-channel trigger for the command. Required.
    # proc<Proc>:: Proc to execute when the command is triggered.
    # &block:: Block to execute when the command is triggered.
    #
    # ==== Callable args
    # sender<String>:: The user and host of the triggering user. Example: botbckt!n=botbckt@unaffiliated/botbckt
    # channel<String>:: The channel on which the command was triggered. Example: #ruby-lang
    # *args:: Any string following the trigger in the message
    #
    def on(command, proc = nil, &block)
      Botbckt::Bot.commands[command.to_sym] = proc || block
    end
    
    # ==== Parameters
    # msg<String>:: A message to send to the channel
    #
    def say(msg)
      Botbckt::Bot.say(msg) if msg
    end
    
  end
  
end

Dir[File.dirname(__FILE__) + '/commands/*'].each { |lib| require lib }
