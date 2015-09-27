module DeviseCastle
  module Mapping
    def self.included(base)
      base.alias_method_chain :default_controllers, :castle
    end

    private
    def default_controllers_with_castle(options)
      options[:controllers] ||= {}
      options[:controllers][:sessions] ||= "devise_castle/sessions"
      options[:controllers][:registrations] ||= "devise_castle/registrations"
      options[:controllers][:passwords] ||= "devise_castle/passwords"
      default_controllers_without_castle(options)
    end
  end
end
