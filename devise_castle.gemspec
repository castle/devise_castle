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
  s.authors = ['Johan Brissmyr']
  s.license = 'MIT'
  s.require_path = "lib"

  s.files = Dir.glob("{app,lib}/**/*")

  s.add_dependency('devise', '~> 3.0')
  s.add_dependency('castle-rb', '~> 1.0.1')

  s.add_development_dependency('bundler', '~> 1.1.0')

  s.add_development_dependency('rake', '~> 0.9')
  s.add_development_dependency('rails', '>= 3.1')
end
