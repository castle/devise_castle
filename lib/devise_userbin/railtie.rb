module DeviseUserbin
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseUserbin::Controllers::Helpers
    end

    config.after_initialize do
      Devise::Mapping.send :include, DeviseUserbin::Mapping
    end
  end
end
