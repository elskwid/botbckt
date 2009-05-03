module Botbckt #:nodoc:
  
  class Weather
    extend Commands
    
    on :forecast do |sender, channel, query|
      begin
        say forecast(query), channel
      # TODO: Log me.
      rescue OpenURI::HTTPError => e
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    on :conditions do |sender, channel, query|
      begin
        say conditions(query), channel
      # TODO: Log me.
      rescue OpenURI::HTTPError => e
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    private
    
    def self.conditions(query)
      xml     = (search(query)/'txt_forecast')
      daytime = (xml/'forecastday[1]')
      evening = (xml/'forecastday[2]')
      
      "Conditions -\nToday: #{(daytime/'fcttext').inner_html}\nTonight: #{(evening/'fcttext').inner_html}"
    end
    
    def self.forecast(query)
      xml = (search(query)/'simpleforecast/forecastday[1]')
      
      "Today's Forecast -\nHigh: #{(xml/'high/fahrenheit').inner_html}F\nLow: #{(xml/'low/fahrenheit').inner_html}F\nConditions: #{(xml/'conditions').inner_html}"
    end
    
    def self.search(query)
      xml = open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{CGI.escape(query)}")
      Hpricot.XML(xml)
    end
    
  end
  
end