begin

  require 'ci/reporter/rake/rspec'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = "--color --format documentation"
  end

  RSpec::Core::RakeTask.new(:code_integrity_spec) do |t|
   t.rspec_opts = "--color --format documentation --pattern '**/*svn_{diff,keywords}_spec.rb'"
  end

rescue LoadError
   # no rspec available
end

task :spec => 'ci:setup:rspec'

task :code_integrity_spec => 'ci:setup:rspec'

task :default => :spec
