require 'rake'
require 'jeweler'
require 'rspec'
require 'rspec/core/rake_task'

task :default => [:spec]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(-fs -c)
  t.pattern = FileList['spec/*_spec.rb']
end

Jeweler::Tasks.new do |s|
  s.name         = 'should_be_faster'
  s.summary      = 'provides rspec matcher to do simple benchmark tests'
  s.email        = 'dsturnbull@gmail.com'
  s.version      = '0.1.0'
  s.authors      = ['David Turnbull']
  s.homepage     = 'http://github.com/dsturnbull/should_be_faster'
  s.files        = ['lib/should_be_faster.rb']
end

