module DeviseUserbin
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter :authenticate_with_userbin
        before_filter :handle_two_factor_authentication
      end

      private

      def authenticate_with_userbin
        Devise.mappings.keys.flatten.any? do |scope|
          if signed_in?(scope)
            begin
              record = warden.user(scope)

              warden.session(scope)['_ubt'] =
                Userbin.authenticate(warden.session(scope)['_ubt'], record.id, {
                  properties: {
                    email: record.email
                  },
                  context: {
                    ip: warden.request.ip,
                    user_agent: warden.request.user_agent
                  }
                })
            rescue Userbin::Error => error
              signed_out = sign_out(scope)
              set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
              redirect_to after_sign_out_path_for(scope)
            end
          end
        end
      end

      def handle_two_factor_authentication
        unless devise_controller?
          Devise.mappings.keys.flatten.any? do |scope|
            if signed_in?(scope)
              if Userbin.two_factor_authenticate!(warden.session(scope)['_ubt'])
                handle_required_two_factor_authentication(scope)
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
