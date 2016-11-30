module DeviseCastle
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseCastle::Controllers::Helpers
    end

    config.after_initialize do
      Devise::Mapping.send :prepend, DeviseCastle::Mapping
    end
  end
end
