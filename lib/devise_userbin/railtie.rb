require 'devise_userbin'
require 'rails'

module DeviseUserbin
  class Engine < Rails::Engine
    config.after_initialize do
      Devise::Mapping.send :include, DeviseUserbin::Mapping
    end
  end
end
