require 'rspec/core/rake_task'
require 'cucumber/rake/task'

namespace :rcov do

  rcov_options = %w{
--rails
--exclude osx\/objc,gems\/,spec\/,features\/,seeds\/
--aggregate coverage/coverage.data
}

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"

    t.rcov = true
    t.rcov_opts = rcov_options
  end

  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.spec_opts = ["--color"]

    t.rcov = true
    t.rcov_opts = rcov_options
    t.rcov_opts += %w{--include views -Ispec}
  end

  desc "Run cucumber & rspec to generate aggregated coverage"
  task :all do |t|
    rm "coverage/coverage.data" if File.exist?("coverage/coverage.data")
    Rake::Task['rcov:rspec'].invoke
    Rake::Task["rcov:cucumber"].invoke
  end
end

