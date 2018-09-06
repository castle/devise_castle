# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_castle/version"

Gem::Specification.new do |s|
  s.name     = 'devise_castle'
  s.version  = DeviseCastle::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.email = 'johan@castle.io'
  s.homepage = 'https://github.com/castle/devise_castle'
  s.summary = 'Devise extension for Castle'
  s.description = 'Devise extension for Castle. Secure your authentication stack with real-time monitoring, instantly notifying you and your users on potential account hijacks.'
  s.authors = ['Johan Brissmyr', 'Sebastian Wallin']
  s.license = 'MIT'
  s.require_path = "lib"

  s.files = Dir.glob("{app,lib,config}/**/*")

  s.add_dependency("devise", ">= 4.0", "< 5")
  s.add_dependency("castle-rb", ">= 2", "< 3")

  s.add_development_dependency('bundler')
  s.add_development_dependency('rake')
  s.add_development_dependency('rails', '>= 4', '< 6')
end
