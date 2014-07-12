# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_userbin/version"

Gem::Specification.new do |s|
  s.name     = 'devise_userbin'
  s.version  = DeviseUserbin::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.email = 'johan@userbin.com'
  s.homepage = 'https://github.com/userbin/devise_userbin'
  s.summary = 'Devise extension for Userbin'
  s.description = 'Devise extension for Userbin. Secure your application with multi-factor authentication, user activity monitoring, and real-time threat protection.'
  s.authors = ['Johan Brissmyr']
  s.license = 'MIT'
  s.require_path = "lib"

  s.files = Dir.glob("{app,lib}/**/*")

  s.add_dependency('devise', '~> 3.0')
  s.add_dependency('userbin', '~> 1.1.1')

  s.add_development_dependency('bundler', '~> 1.1.0')

  s.add_development_dependency('rake', '~> 0.9')
  s.add_development_dependency('rails', '>= 3.1')
end
