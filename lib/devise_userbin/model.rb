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

      included do
        before_create :create_userbin_user
        before_update :update_userbin_user
        before_destroy :destroy_userbin_user

        def create_userbin_user
          userbin_user_block do
            user = ::Userbin::User.create(email: email)
            self.userbin_id = user.id
          end
        end

        def update_userbin_user
          if %w[email].any? { |attr| changed.include?(attr) }
            userbin_user_block do
              ::Userbin::User.save_existing(userbin_id, email: email)
            end
          end
        end

        def destroy_userbin_user
          userbin_user_block do
            ::Userbin::User.destroy_existing(userbin_id)
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
      end

    end
  end
end
