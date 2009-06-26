module Botbckt #:nodoc:
  
  # Displays a simple forecast or a prosaic description of today's conditions.
  #
  #  < user> ~forecast 90210
  #  < botbckt> Today's Forecast: 90F/65F (Sunny)
  #
  #  < user> ~conditions Los Angeles, CA
  #  < botbckt> Today: Areas of low clouds in the morning then mostly sunny. Highs in the upper 60s to mid 70s. West winds 10 to 20 mph in the afternoon.
  #  < botbckt> Tonight: Mostly clear. Lows in the mid to upper 50s. West winds 10 to 20 mph in the evening.
  #
  class Weather < Command
    
    trigger :forecast do |sender, channel, query|
      begin
        forecast(query) do |msg|
          say msg, channel
        end
      # TODO: Log me.
      rescue OpenURI::HTTPError => e
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    trigger :conditions do |sender, channel, query|
      begin
        conditions(query) do |msg|
          say msg, channel
        end
      # TODO: Log me.
      rescue OpenURI::HTTPError => e
        say Botbckt::Bot.befuddled, channel
      end
    end
    
    private
    
    def self.conditions(query, &block) #:nodoc:
      search(query) do |response|
        xml     = (response/'txt_forecast')
        daytime = (xml/'forecastday[1]')
        evening = (xml/'forecastday[2]')
      
        yield "Today: #{(daytime/'fcttext').inner_html}\nTonight: #{(evening/'fcttext').inner_html}"
      end
    end
    
    def self.forecast(query, &block) #:nodoc:
      search(query) do |response|
        xml = (response/'simpleforecast/forecastday[1]')
      
        yield "Today's Forecast: #{(xml/'high/fahrenheit').inner_html}F/#{(xml/'low/fahrenheit').inner_html}F (#{(xml/'conditions').inner_html})"
      end
    end
    
    def self.search(query, &block) #:nodoc:
      open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{CGI.escape(query)}") do |xml|
        yield Hpricot.XML(xml)
      end
    end
    
  end
  
end