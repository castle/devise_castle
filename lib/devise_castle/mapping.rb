module DeviseCastle
  module Mapping

    private
    def default_controllers(options)
      options[:controllers] ||= {}
      options[:controllers][:sessions] ||= "devise_castle/sessions"
      options[:controllers][:registrations] ||= "devise_castle/registrations"
      options[:controllers][:passwords] ||= "devise_castle/passwords"
      super
    end
  end
end
