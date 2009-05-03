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
    
    def conditions
      xml     = (search(query)/'txt_forecast')
      daytime = (xml/'forecastday[1]')
      evening = (xml/'forecastday[2]')
      
      str = <<-EOF
        Conditions -\n
        Today: #{daytime/'fcttext'}\n
        Tonight: #{evening/'fcttext'}
      EOF
    end
    
    def forecast(query)
      xml = (search(query)/'simpleforecast/forecastday[1]')
      
      str = <<-EOF
        Today's Forecast -\n
        High: #{xml/'high/fahrenheit'}F\n
        Low: #{xml/'low/fahrenheit'}F\n
        Conditions: #{xml/'conditions'}
      EOF
    end
    
    def search(query)
      xml = open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{CGI.escape(query)}")
      Hpricot.XML(xml)
    end
    
  end
  
end