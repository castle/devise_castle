module DeviseUserbin
  module Views
    module Helpers

      def security_page_url(opts = {})
        scope = opts[:scope] || ::Devise.default_scope
        session_id = warden.session(scope)['_ubt']
        if session_id
          begin
            app_id = Userbin::JWT.new(session_id).app_id
            "https://#{app_id}.userbin.com/?session_id=#{session_id}"
          rescue Userbin::Error; end
        end
      end

    end
  end
end
