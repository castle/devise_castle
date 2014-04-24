require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class Userbin < Authenticatable
      def authenticate!
        resource = mapping.to.find_for_userbin_authentication(
          authentication_hash, password)
        resource ? success!(resource) : fail(:not_found_in_database)
      end
    end
  end
end

Warden::Strategies.add(:userbin, Devise::Strategies::Userbin)
