module DeviseUserbin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Add DeviseUserbin config variables to the Devise initializer"
      argument :api_secret, :desc => "Your Userbin API secret, which can be found on your Userbin dashboard."

      def add_config_options_to_initializer
        devise_initializer_path = "config/initializers/devise.rb"
        if File.exist?(devise_initializer_path)
          old_content = File.read(devise_initializer_path)

          if old_content.match(Regexp.new(/^\s*# ==> Configuration for :userbin\n/))
            false
          else
            inject_into_file(devise_initializer_path, :before => "  # ==> Mailer Configuration\n") do
<<-CONTENT
  # ==> Configuration for :userbin
  config.userbin_api_secret = '#{api_secret}'

CONTENT
                  end
                end
              end
            end
    end
  end
end
