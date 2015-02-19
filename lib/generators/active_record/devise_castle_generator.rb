require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseCastleGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_devise_castle_migration
        migration_template "migration.rb", "db/migrate/add_castle_to_#{table_name}.rb"
      end

    end
  end
end
