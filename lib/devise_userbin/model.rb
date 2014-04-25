require 'devise_userbin/strategy'

module Devise
  module Models
    module Userbin
      extend ActiveSupport::Concern

      ::Userbin.config.app_id = Devise.userbin_app_id
      ::Userbin.config.api_secret = Devise.userbin_api_secret

      included do
        attr_reader :current_password
        attr_accessor :password, :password_confirmation

        before_create do
          begin
            user = ::Userbin::User.create(email: email, password: password)
            self.userbin_id = user.id
          rescue ::Userbin::Error => error
            self.errors[:base] << error.to_s
            false
          end
        end
      end

      module ClassMethods
        def find_for_userbin_authentication(attributes={}, password)
          begin
            user = ::Userbin::User.authenticate(
              'credentials[email]' => attributes[:email],
              'credentials[password]' => password
            )
          rescue ::Userbin::Error => error
            return
          end

          to_adapter.find_first(
            devise_parameter_filter.filter({userbin_id: user.id}))
        end
      end

    end
  end
end
