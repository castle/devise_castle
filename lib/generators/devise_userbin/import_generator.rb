module DeviseUserbin
  module Generators
    class ImportGenerator < Rails::Generators::NamedBase
      desc "Import users to Userbin"

      def import_users_to_userbin
        Import.run(resource_class: class_name)
      end

    end
  end
end
