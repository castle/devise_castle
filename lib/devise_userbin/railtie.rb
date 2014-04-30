module DeviseUserbin
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseUserbin::Controllers::Helpers
    end
    ActiveSupport.on_load(:action_view) do
      include DeviseUserbin::Views::Helpers
    end
  end
end
