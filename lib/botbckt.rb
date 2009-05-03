%w{ rubygems eventmachine activesupport ostruct json open-uri cgi hpricot }.each { |lib| require lib }
%w{ irc bot commands }.each { |lib| require File.dirname(__FILE__) + "/botbckt/#{ lib }" }

Botbckt::Bot.start :user => 'botbckt', :server => 'irc.freenode.net', :port => 6667, :channels => ['reno.rb']
