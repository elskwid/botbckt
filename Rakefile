require 'rake/rdoctask'

Rake::RDocTask.new do |rd|
  rd.main     = 'README'
  rd.rdoc_dir = 'doc'
  rd.rdoc_files.include('README', 'lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |g|
    g.name        = 'botbckt'
    g.summary     = 'Boredom strikes on Sunday mornings.'
    g.email       = 'brandon@systemisdown.net'
    g.homepage    = 'http://github.com/bitbckt/botbckt'
    g.description = 'Boredom strikes on Sunday mornings.'
    g.authors     = ['Brandon Mitchell']
    g.executables << 'botbckt'
    g.add_dependency('eventmachine', '>= 0.12.0')
    g.add_dependency('activesupport')
    g.add_dependency('json', '>= 1.1.2')
    g.add_dependency('hpricot', '>= 0.6')
    g.add_dependency('em-redis', '>= 0.1.1')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end