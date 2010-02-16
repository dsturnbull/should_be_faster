require 'rake'
require 'jeweler'
require 'spec'
require 'spec/rake/spectask'

task :default => [:spec]

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = %w(-fs -c)
  t.spec_files = FileList['spec/*_spec.rb']
end

Jeweler::Tasks.new do |gemspec|
  gemspec.name         = 'should_be_faster'
  gemspec.summary      = 'provides rspec matcher to do simple benchmark tests'
  gemspec.email        = 'dsturnbull@gmail.com'
  gemspec.version      = '0.0.1'
  gemspec.authors      = ['David Turnbull']
  gemspec.homepage     = 'http://github.com/dsturnbull/should_be_faster'
  gemspec.files        = ['lib/should_be_faster.rb']
  gemspec.add_runtime_dependency 'rspec' 
end

