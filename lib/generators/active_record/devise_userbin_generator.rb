require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseUserbinGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_devise_userbin_migration
        migration_template "migration.rb", "db/migrate/add_userbin_to_#{table_name}.rb"
      end

    end
  end
end
