# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_userbin/version"

Gem::Specification.new do |s|
  s.name     = 'devise_userbin'
  s.version  = DeviseUserbin::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary  = 'Devise extension to allow authentication via Userbin'
  s.email = 'johan@userbin.com'
  s.homepage = 'https://github.com/userbin/devise_userbin'
  s.description = s.summary
  s.authors = ['Johan Brissmyr']
  s.license = 'MIT'
  s.require_path = "lib"

  s.files = `git ls-files {app,rails,lib}`.split("\n") + %w[README.md]

  s.add_dependency('devise', '>= 3.0')

  s.add_development_dependency('bundler', '>= 1.1.0')

  s.add_development_dependency('rake', '>= 0.9')
  s.add_development_dependency('rails', '>= 4.0')
end
