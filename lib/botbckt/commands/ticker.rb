module Botbckt
  
  class Ticker
    extend Commands
    
    on :ticker do |symbol, *args|
      say stock_price(symbol)
    end
    
    private
    
    def self.stock_price(symbol)
      json     = open("http://www.google.com/finance/info?q=#{CGI.escape(symbol)}")
      response = JSON.parse(json.read[4..-1]).first
      
      ticker, price, change = response['t'], response['l'], response['c']
      
      "#{ticker} - $#{price} (#{change})"
    end
  end
  
end