require 'active_support/concern'
require 'devise'
require 'devise_castle/hooks'
require 'devise_castle/mapping'
require 'devise_castle/routes'
require 'castle'
require 'castle/support/rails'

module Devise
  mattr_accessor :castle_api_secret
  mattr_accessor :castle_error_handler
  @@castle_api_secret = ''
  @@castle_error_handler = nil
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
  :controller => :devise_castle,
  :route => :castle,
  :model  => 'devise_castle/model')
