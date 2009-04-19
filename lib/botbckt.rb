%w{ rubygems eventmachine activesupport ostruct json open-uri cgi }.each { |lib| require lib }
%w{ irc bot commands }.each { |lib| require File.dirname(__FILE__) + "/botbckt/#{ lib }" }
