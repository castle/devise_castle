module DeviseCastle
  module Generators
    class DeviseCastleGenerator < Rails::Generators::NamedBase
      namespace "devise_castle"

      desc "Add :castle directive in the given model. Also generate migration for ActiveRecord"

      def inject_devise_castle_content
        path = File.join("app", "models", "#{file_path}.rb")
        if File.exists?(path)
          inject_into_file(path, "castle, :", :after => "devise :")
        end
      end
    end
  end
end
