require 'em-redis'

module Botbckt #:nodoc:
  
  # Implements a basic key/value store API for cross-session state storage.
  #
  # Currently, this class is Redis-backed, but any key/value store could be
  # supported, in theory.
  #
  class Store
    
    attr_accessor :backend
    
    # ==== Parameters
    # host<String>:: IP address or hostname of the Redis server. Required.
    # port<Integer>:: Port the Redis server is listening on. Required.
    #
    def initialize(host, port)
      self.backend = EventMachine::Protocols::Redis.connect(host, port)
    end
    
    # Sets the key to the given value, creating the key if necessary.
    #
    # ==== Parameters
    # key<String>:: The identifier for this value. Required.
    # value<Object>:: The value to store at the key. Required.
    # &block:: A callback to execute after the value is stored. The block should
    #          take a single parameter: the value stored. Optional.
    #
    def set(key, value, &block)
      backend.set(key, value, &block)
    end

    # Retrieves the value stored at key. Returns nil if the key does not exist.
    #
    # ==== Parameters
    # key<String>:: The identifier to retrieve. Required.
    # &block:: A callback to execute after the value is retrieved. The block should
    #          take a single parameter: the value retrieved. Required.
    #
    def get(key, &block)
      return unless block_given?
      backend.get(key, &block)
    end
    
    # Increments the value stored at key by 1, creating the key and initializing
    # it to 0 if necessary.
    #
    # ==== Parameters
    # key<String>:: The identifier whose value should be incremented. Required.
    # &block:: A callback to execute after the value is stored. The block should
    #          take a single parameter: the value stored. Optional.
    #
    def increment!(key, &block)
      backend.incr(key, &block)
    end
    
  end
  
end
    