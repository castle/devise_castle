# require File.expand_path('spec/rails_app/config/environment', File.dirname(__FILE__))
require 'bundler'
require 'rdoc/task'

# desc 'Default: run test suite.'
# task :default => :spec

Bundler::GemHelper.install_tasks

desc 'Generate documentation for the devise_castle plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'DeviseCastle'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# RailsApp::Application.load_tasks
