module DeviseUserbin
  module Views
    module Helpers

      def security_page_url(opts = {})
        scope = opts[:scope] || ::Devise.default_scope
        token = warden.session(scope)['_ubt']
        Userbin.security_page_url(token)
      end

    end
  end
end
