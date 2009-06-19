module Botbckt #:nodoc:
  
  class Cmd
    
    SEVERITY = %w{0 1 2 3 4 5}
    SEVERITY_ALIASES = { "DEBUG" => 0, "INFO" => 1, "WARN" => 2, "ERROR" => 3, "FATAL" => 4, "UNKNOWN" => 5}
    
    def self.run(args)
      Botbckt::Bot.start parse(args)
    end
    
    def self.parse(args)
      options = {}
      options[:user] = 'botbckt'
      options[:port] = 6667
      options[:channels] = []
      
      opts = OptionParser.new do |opts|
        opts.banner = 'Usage: botbckt [options]'
      
        opts.separator ''
        opts.separator 'Options:'
        
        opts.on('-u', '--user [USER]', 'Username to identify as. (default: botbckt)') do |user|
          options[:user] = user
        end
        
        opts.on('-p', '--password [PASSWORD]', 'Password to authenticate with.') do |pass|
          options[:password] = pass
        end
        
        opts.on('-s', '--server SERVER', 'Address of the IRC server.') do |server|
          options[:server] = server
        end
        
        opts.on('-p', '--port [PORT]', Integer, 'Port of the IRC server. (default: 6667)') do |port|
          options[:port] = port
        end
        
        opts.on('-c', '--channels [x,y,z]', Array,
                'Comma-separated list of channels to JOIN. Do not include the # prefix.') do |channels|
          options[:channels] = channels
        end
      
        opts.on('-l', '--logfile [FILE]', 'Log file. (default botbckt.log)') do |log|
          options[:log] = log
        end
      
        severities = SEVERITY_ALIASES.keys.join(', ')
        opts.on('-V', '--verbosity [LEVEL]', SEVERITY, SEVERITY_ALIASES, Integer,
                "Minimum severity level to log.Accepted values are: #{severities}. (default: INFO)") do |level|
          options[:log_level] = level
        end
      
        opts.on('-D', '--[no-]daemonize', 'Fork and run in the background. (default: true)') do |daemon|
          options[:daemonize] = daemon
        end
        
        opts.on_tail('-h', '--help', 'Show this message.') do |help|
          puts opts
          exit
        end
      end
      
      opts.parse!(args)
      options
    rescue OptionParser::ParseError
      puts opts
      exit
    end
    
  end
end