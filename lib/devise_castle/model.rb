module Devise
  module Models
    module Castle
      extend ActiveSupport::Concern

      ::Castle.api_secret = Devise.castle_api_secret

      included do
        before_destroy :destroy_castle_user

        def destroy_castle_user
          castle_user_block do
            ::Castle::User.destroy_existing(id)
          end
        end

        def castle_user_block
          begin
            yield
          rescue ::Castle::Error
            true
          end
        end

        # Override this in your Devise model to use a custom identifier
        # for the Castle API:s
        def castle_id
          id
        end

        # Since the identifier will be used in API routes, it needs to be
        # URI encoded
        def _castle_id
          URI.encode(castle_id.to_s)
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
