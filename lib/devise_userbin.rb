require 'devise'
require 'devise_userbin/mapping'
require 'devise_userbin/warden'
require 'devise_userbin/import'

if defined?(Rails::Railtie)
  require 'devise_userbin/railtie'
  Rails::Engine
end

module Devise
  mattr_accessor :userbin_app_id
  @@userbin_app_id = ''

  mattr_accessor :userbin_api_secret
  @@userbin_api_secret = ''
end

Devise.add_module(:userbin,
  :strategy => true,
  :controller => :sessions,
  :route => :session,
  :model  => 'devise_userbin/model')
