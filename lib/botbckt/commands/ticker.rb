module Botbckt #:nodoc:
  
  # Grabs the current stock price of a symbol from Google Finance and displays
  # in-channel:
  #
  #  < user> ~ticker GOOG
  #  < botbckt> GOOG - $391.06 (+0.06)
  #
  class Ticker
    extend Commands
    
    on :ticker do |sender, channel, symbol|
      stock_price symbol.split(' ').first, channel
    end
    
    private
    
    def self.stock_price(symbol, channel) #:nodoc:
      json     = open("http://www.google.com/finance/info?q=#{CGI.escape(symbol)}")
      response = JSON.parse(json.read[4..-1]).first
      
      ticker, price, change = response['t'], response['l'], response['c']
      
      say "#{ticker} - $#{price} (#{change})", channel
    rescue OpenURI::HTTPError => e
      say Botbckt::Bot.befuddled, channel
    end
  end
  
end
