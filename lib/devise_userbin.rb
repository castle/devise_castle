require 'active_support/concern'
require 'devise'
require 'devise_userbin/hooks'
require 'devise_userbin/routes'
require 'devise_userbin/hooks'
require 'devise_userbin/import'

if defined?(Rails::Railtie)
  require 'devise_userbin/railtie'
  Rails::Engine
end

module Devise
  mattr_accessor :userbin_api_secret
  @@userbin_api_secret = ''
end

module DeviseUserbin
  module Controllers
    autoload :Helpers, 'devise_userbin/controllers/helpers'
  end
end

Devise.add_module(:userbin,
  :controller => :two_factor_authentication,
  :route => :userbin,
  :model  => 'devise_userbin/model')
