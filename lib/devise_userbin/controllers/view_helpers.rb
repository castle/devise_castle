module DeviseUserbin
  module Views
    module Helpers

      def security_page_url(opts = {})
        scope = opts[:scope] || ::Devise.default_scope
        session_token = session["#{scope}_userbin"]
        Userbin.security_page_url(session_token)
      end

    end
  end
end
