module Botbckt #:nodoc:
  
  # Grabs the current stock price of a symbol from Google Finance and displays
  # in-channel:
  #
  #  < user> ~ticker GOOG
  #  < botbckt> GOOG - $391.06 (+0.06)
  #
  class Ticker < Command
    
    trigger :ticker
    
    def call(sender, channel, symbol)
      begin
        say stock_price(symbol.split(' ').first), channel
      # TODO: Log me.
      rescue OpenURI::HTTPError => e
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    private
    
    def stock_price(symbol) #:nodoc:
      json     = open("http://www.google.com/finance/info?q=#{CGI.escape(symbol)}")
      response = JSON.parse(json.read[4..-1]).first
      
      ticker, price, change = response['t'], response['l'], response['c']
      
      "#{ticker} - $#{price} (#{change})"
    end
  end
  
end
