require 'fileutils'
require 'rspec/core/rake_task'

desc "Run spec suite (uses Rspec2)"
RSpec::Core::RakeTask.new(:spec) { |t| }

namespace :spec do
  desc "Clean up rbx compiled files and run spec suite"
  RSpec::Core::RakeTask.new(:ci) { |t| Dir.glob("**/*.rbc").each { |f| FileUtils.rm_f(f) } }
end

desc "Build the gem"
task :gem do
  sh 'gem build *.gemspec'
end
