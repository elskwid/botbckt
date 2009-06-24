%w{ rubygems eventmachine activesupport ostruct json open-uri cgi hpricot singleton optparse em-redis }.each { |lib| require lib }
%w{ irc store bot utilities command cmd }.each { |lib| require File.dirname(__FILE__) + "/botbckt/#{ lib }" }
Dir[File.dirname(__FILE__) + '/botbckt/commands/*'].each { |lib| require lib }
