module Devise
  module Models
    module Userbin
      extend ActiveSupport::Concern

      ::Userbin.api_secret = Devise.userbin_api_secret

      # Overwrites valid_for_authentication? from Devise::Models::Authenticatable
      # for verifying whether a user is allowed to sign in or not.
      def valid_for_authentication?
        return super unless persisted?

        if super
          # TODO: track successful login
          true
        else
          # TODO: track unsuccessful login
          false
        end
      end
    end
  end
end
