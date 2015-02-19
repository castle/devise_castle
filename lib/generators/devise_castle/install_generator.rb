module DeviseCastle
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Add DeviseCastle config variables to the Devise initializer"
      argument :api_secret, :desc => "Your Castle API secret, which can be found on your Castle dashboard."

      def add_config_options_to_initializer
        devise_initializer_path = "config/initializers/devise.rb"
        if File.exist?(devise_initializer_path)
          old_content = File.read(devise_initializer_path)

          if old_content.match(Regexp.new(/^\s*# ==> Configuration for :castle\n/))
            false
          else
            inject_into_file(devise_initializer_path, :before => "  # ==> Mailer Configuration\n") do
<<-CONTENT
  # ==> Configuration for :castle
  config.castle_api_secret = '#{api_secret}'

CONTENT
            end
          end
        end
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise_castle.en.yml"
      end
    end
  end
end
