begin

  require 'ci/reporter/rake/rspec'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--color --format documentation"
  end

rescue LoadError
   # no rspec available
end

task :spec => 'ci:setup:rspec'

task :default => :spec
