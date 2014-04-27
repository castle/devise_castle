module DeviseUserbin
  module Generators
    class DeviseUserbinGenerator < Rails::Generators::NamedBase
      namespace "devise_userbin"

      desc "Add :userbin directive in the given model. Also generate migration for ActiveRecord"

      def inject_devise_userbin_content
        path = File.join("app", "models", "#{file_path}.rb")
        if File.exists?(path)
          inject_into_file(path, "userbin, :", :after => "devise :")
        end
      end

      hook_for :orm
    end
  end
end
