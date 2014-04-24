require 'devise'
require 'devise_userbin/mapping'
require 'devise_userbin/warden'
require 'devise_userbin/import'

if defined?(Rails::Railtie)
  require 'devise_userbin/railtie'
  Rails::Engine
end

Devise.add_module(:userbin,
  :strategy => true,
  :controller => :sessions,
  :route => :session,
  :model  => 'devise_userbin/model')
