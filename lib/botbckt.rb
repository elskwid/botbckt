%w{ rubygems eventmachine activesupport ostruct json cgi hpricot singleton optparse em-redis em-http }.each { |lib| require lib }
%w{ irc store bot utilities command cmd }.each { |lib| require File.dirname(__FILE__) + "/botbckt/#{ lib }" }
Dir[File.dirname(__FILE__) + '/botbckt/commands/*'].each { |lib| require lib }

module Kernel
  private
  alias open_uri_original_open open

  def open(name, *rest, &block) #:nodoc:
    if name.respond_to?(:open)
      name.open(*rest, &block)
    elsif name.respond_to?(:to_str) &&
          %r{\A[A-Za-z][A-Za-z0-9+\-\.]*://} =~ name
      uri     = URI.parse(name)
      http    = EventMachine::HttpRequest.new("#{uri.scheme}://#{uri.host}#{uri.path}").get :query => uri.query
      http.callback { |request| yield request.response }
    else
      open_uri_original_open(name, *rest, &block)
    end
  end
  module_function :open

end
