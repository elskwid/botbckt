require 'em-redis'

module Botbckt #:nodoc:
  
  # Implements a basic key/value store API for cross-session state storage.
  #
  # Currently, this class is Redis-backed, but any key/value store could be
  # supported, in theory.
  #
  class Store
    
    attr_accessor :backend
    
    def initialize(host, port)
      self.backend = EventMachine::Protocols::Redis.connect(host, port)
    end
    
    def set(key, value)
      backend.set(key, value) do |response|
        response
      end
    end
    
    def get(key)
      backend.get(key) do |response|
        response
      end
    end
    
    def increment!(key)
      backend.incr(key) do |response|
        response
      end
    end
    
  end
  
end
    