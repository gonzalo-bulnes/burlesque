require 'rails/generators/migration'

module Burlesque
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates',          __FILE__)

      def generate_models
        create_model 'role'
        create_model 'authorization'
      end

      def create_model name
        _model_name = name
        _table_name = name.pluralize

        # Crea el modelo
        copy_file           "#{_model_name}.rb",        "app/models/#{_model_name}.rb"
        # Crea la tabla del modelo
        migration_template  "create_#{_table_name}.rb", "db/migrate/create_#{_table_name}.rb"
      end

      def get_current_migration_number
        Dir.glob("#{Rails.root}/db/migrate/[0-9]*_*.rb").inject(0) do |max, file_path|
          n = File.basename(file_path).split('_', 2).first.to_i
          if n > max then n else max end
        end
      end

      def self.next_migration_number path
        ActiveRecord::Migration.new.next_migration_number(get_current_migration_number)
      end
    end
  end
end