module DeviseUserbin
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter :handle_two_factor_authentication
      end

      private

      def handle_two_factor_authentication
        unless devise_controller?
          Devise.mappings.keys.flatten.any? do |scope|
            if signed_in?(scope)
              unless session["#{scope}_userbin_authenticated"]
                challenge = Userbin.two_factor_authenticate!(
                  session["#{scope}_userbin"])
                if challenge
                  session["#{scope}_userbin_challenge_id"] = challenge.id
                  handle_required_two_factor_authentication(scope)
                end
              end
            end
          end
        end
      end

      def handle_required_two_factor_authentication(scope)
        if request.format.present? and request.format.html?
          session["#{scope}_return_to"] = request.path if request.get?
          redirect_to two_factor_authentication_path_for(scope)
        else
          render nothing: true, status: :unauthorized
        end
      end

      def two_factor_authentication_path_for(resource_or_scope = nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        change_path = "#{scope}_two_factor_authentication_path"
        send(change_path)
      end

    end
  end
end
