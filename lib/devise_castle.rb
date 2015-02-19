require 'active_support/concern'
require 'devise'
require 'devise_castle/hooks'
require 'devise_castle/routes'
require 'devise_castle/hooks'
require 'devise_castle/import'
require 'devise_castle/mapping'
require 'castle'

module Devise
  mattr_accessor :castle_api_secret
  @@castle_api_secret = ''
end

module DeviseCastle
  module Controllers
    autoload :Helpers, 'devise_castle/controllers/helpers'
  end
end

if defined?(Rails::Railtie)
  require 'devise_castle/railtie'
  Rails::Engine
end

Devise.add_module(:castle,
  :controller => :two_factor_authentication,
  :route => :castle,
  :model  => 'devise_castle/model')
