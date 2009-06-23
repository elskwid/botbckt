# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{botbckt}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brandon Mitchell"]
  s.date = %q{2009-06-23}
  s.default_executable = %q{botbckt}
  s.description = %q{Boredom strikes on Sunday mornings.}
  s.email = %q{brandon@systemisdown.net}
  s.executables = ["botbckt"]
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "Rakefile",
    "VERSION.yml",
    "bin/botbckt",
    "lib/botbckt.rb",
    "lib/botbckt/bot.rb",
    "lib/botbckt/cmd.rb",
    "lib/botbckt/command.rb",
    "lib/botbckt/commands/gooble.rb",
    "lib/botbckt/commands/google.rb",
    "lib/botbckt/commands/meme.rb",
    "lib/botbckt/commands/ping.rb",
    "lib/botbckt/commands/remind.rb",
    "lib/botbckt/commands/snack.rb",
    "lib/botbckt/commands/star_jar.rb",
    "lib/botbckt/commands/ticker.rb",
    "lib/botbckt/commands/weather.rb",
    "lib/botbckt/irc.rb",
    "lib/botbckt/store.rb",
    "lib/botbckt/utilities.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/bitbckt/botbckt}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Boredom strikes on Sunday mornings.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
