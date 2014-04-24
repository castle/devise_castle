module DeviseUserbin
  module Mapping
    def self.included(base)
      base.alias_method_chain :default_controllers, :userbin
    end

    private
    def default_controllers_with_userbin(options)
      options[:controllers] ||= {}
      options[:controllers][:registrations] ||= "devise_userbin/registrations"
      default_controllers_without_userbin(options)
    end
  end
end
