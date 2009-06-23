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
    
    def set(key, value, &block)
      backend.set(key, value, &block)
    end
    
    def get(key, &block)
      backend.get(key, &block)
    end
    
    def increment!(key, &block)
      backend.incr(key, &block)
    end
    
  end
  
end
    