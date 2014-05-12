module Devise
  module Models
    module Userbin
      extend ActiveSupport::Concern

      ::Userbin.api_secret = Devise.userbin_api_secret

      included do
        before_destroy :destroy_userbin_user

        def destroy_userbin_user
          userbin_user_block do
            ::Userbin::User.destroy_existing(id)
          end
        end

        def userbin_user_block
          begin
            yield
          rescue ::Userbin::Error => error
            self.errors[:base] << error.to_s
            false
          end
        end

        # Override this in your Devise model to use a custom identifier
        # for the Userbin API:s
        def userbin_id
          id
        end

        # Since the identifier will be used in API routes, it needs to be
        # URI encoded
        def _userbin_id
          URI.encode(userbin_id.to_s)
        end
      end

      # Overwrites valid_for_authentication? from Devise::Models::Authenticatable
      # for verifying whether a user is allowed to sign in or not.
      def valid_for_authentication?
        return super unless persisted?

        if super
          true
        else
          # TODO: track unsuccessful login
          false
        end
      end
    end
  end
end
