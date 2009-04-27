module Botbckt

  # Sends a query to Google via the JSON API and returns output in-channel:
  #
  # < user> ~google ruby
  # < botbckt> First out of 93900000 results:
  # < botbckt> Ruby Programming Language
  # < botbckt> http://www.ruby-lang.org/
  #
  # Inspired by Clojurebot: http://github.com/hiredman/clojurebot
  #
  class Google
    extend Commands
  
    on :google do |query, *args|
      result = google(query)
      say "First out of #{result.first} results:"
      say result.last['titleNoFormatting']
      say result.last['unescapedUrl']
    end
  
    private
  
    def self.google(term) #:nodoc:
      json     = open("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{CGI.escape(term)}")
      response = JSON.parse(json.read)

      [
        response['responseData']['cursor']['estimatedResultCount'],
        response['responseData']['results'].first
      ]
    end

  end
end