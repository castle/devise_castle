require 'devise_userbin/strategy'

module Devise
  module Models
    module Userbin
      extend ActiveSupport::Concern

      included do
        attr_reader :password, :current_password
        attr_accessor :password_confirmation

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

      def password=(new_password)
        @password = new_password
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
