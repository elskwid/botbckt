module Botbckt #:nodoc:
  
  # Displays a simple forecast or a prosaic description of today's conditions.
  #
  #  < user> ~forecast 90210
  #  < botbckt> Today's Forecast: 90F/65F (Sunny)
  #
  #  < user> ~conditions Los Angeles, CA
  #  < botbckt> Conditions -
  #  < botbckt> Today: Areas of low clouds in the morning then mostly sunny. Highs in the upper 60s to mid 70s. West winds 10 to 20 mph in the afternoon.
  #  < botbckt> Tonight: Mostly clear. Lows in the mid to upper 50s. West winds 10 to 20 mph in the evening.
  #
  class Weather < Command
    
    trigger :forecast do |sender, channel, query|
      begin
        say forecast(query), channel
      # TODO: Log me.
      rescue OpenURI::HTTPError => e
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    trigger :conditions do |sender, channel, query|
      begin
        say conditions(query), channel
      # TODO: Log me.
      rescue OpenURI::HTTPError => e
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    private
    
    def self.conditions(query) #:nodoc:
      xml     = (search(query)/'txt_forecast')
      daytime = (xml/'forecastday[1]')
      evening = (xml/'forecastday[2]')
      
      "Today: #{(daytime/'fcttext').inner_html}\nTonight: #{(evening/'fcttext').inner_html}"
    end
    
    def self.forecast(query) #:nodoc:
      xml = (search(query)/'simpleforecast/forecastday[1]')
      
      "Today's Forecast: #{(xml/'high/fahrenheit').inner_html}F/#{(xml/'low/fahrenheit').inner_html}F (#{(xml/'conditions').inner_html})"
    end
    
    def self.search(query) #:nodoc:
      xml = open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{CGI.escape(query)}")
      Hpricot.XML(xml)
    end
    
  end
  
end