require 'devise_userbin'
require 'rails'

module DeviseUserbin
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseUserbin::Controllers::Helpers
    end
  end
end
