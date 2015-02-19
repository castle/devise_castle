module DeviseCastle
  module Generators
    class ImportGenerator < Rails::Generators::NamedBase
      desc "Import users to Castle"

      def import_users_to_castle
        Import.run(resource_class: class_name)
      end

    end
  end
end
