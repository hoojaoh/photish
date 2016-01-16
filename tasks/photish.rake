require 'photish/rake/task'

namespace :photish do
  Photish::Rake::Task.new(:init, 'Creates a basic project') do |t|
    t.options = "init"
  end

  Photish::Rake::Task.new(:generate, 'Generates all the code') do |t|
    t.options = "generate"
  end

  Photish::Rake::Task.new(:host, 'Starts a HTTP and hosts the code') do |t|
    t.options = "host"
  end

  task :all => [:init, :generate, :host]
end
