module DeviseUserbin
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter do
          env['userbin'] = userbin
        end

        rescue_from Userbin::UserUnauthorizedError do |error|
          Devise.mappings.keys.flatten.any? do |scope|
            warden.logout(scope)
            throw :warden, :scope => scope, :message => :signed_out
          end
        end

        rescue_from Userbin::ChallengeRequiredError do |error|
          Devise.mappings.keys.flatten.any? do |scope|
            if request.format.present? and request.format.html?
              session["#{scope}_return_to"] = request.path if request.get?
              # todo: doesn't seem to work
              redirect_to send("new_#{scope}_two_factor_authentication_path")
            else
              render nothing: true, status: :unauthorized
            end
          end
        end
      end

    end
  end
end
