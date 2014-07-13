module DeviseUserbin
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter :authorize_resource
        before_filter :handle_two_factor_authentication
      end

      private

      def authorize_resource
        Devise.mappings.keys.flatten.any? do |scope|
          if signed_in?(scope)
            resource = send("current_#{scope}")

            begin
              env['userbin'].authorize!(
                resource._userbin_id, email: resource.email)
            rescue Userbin::Error
              warden.logout(scope)
              throw :warden, :scope => scope, :message => :signed_out
            end
          end
        end
      end

      def handle_two_factor_authentication
        if !devise_controller? && env['userbin'].authorized?
          Devise.mappings.keys.flatten.any? do |scope|
            if signed_in?(scope)
              begin
                factor = env['userbin'].two_factor_authenticate!

                # Show form and message specific to the current factor
                case factor
                when :authenticator
                  handle_required_two_factor_authentication(scope)
                end
              rescue Userbin::Error
                warden.logout(scope)
                throw :warden, :scope => scope, :message => :signed_out
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
