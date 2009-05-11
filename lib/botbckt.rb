%w{ rubygems eventmachine activesupport ostruct json open-uri cgi hpricot singleton }.each { |lib| require lib }
%w{ irc bot utilities command }.each { |lib| require File.dirname(__FILE__) + "/botbckt/#{ lib }" }
Dir[File.dirname(__FILE__) + '/botbckt/commands/*'].each { |lib| require lib }
