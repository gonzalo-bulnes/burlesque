module Burlesque
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_models
        create_model 'burlesque_role'
        create_model 'burlesque_authorization'

        create_table 'burlesque_roles'
        create_table 'burlesque_authorizations'
      end

      def get_current_migration_number
        Dir.glob("#{Rails.root}/db/migrate/[0-9]*_*.rb").inject(0) do |max, file_path|
          n = File.basename(file_path).split('_', 2).first.to_i
          if n > max then n else max end
        end
      end

      def get_next_migration_number
        ActiveRecord::Migration.new.next_migration_number(get_current_migration_number)
      end

      def migration_exists?(table_name)
        Dir.glob("#{File.join(Rails.root, 'db/migrate')}/[0-9]*_*.rb").grep(/\d+_create_#{table_name}.rb$/).first
      end

      def create_model name
        copy_file "#{name}.rb", "app/models/#{name}.rb"
      end
      def create_table name
        unless migration_exists? name
          copy_file "#{name}.rb", "db/migrate/#{get_next_migration_number}_create_#{name}.rb"
        end
      end
    end
  end
end