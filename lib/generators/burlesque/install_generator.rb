module Burlesque
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_models
        copy_file "burlesque_role.rb",          "app/models/burlesque_role.rb"
        copy_file "burlesque_authorization.rb", "app/models/burlesque_authorization.rb"

        copy_file "create_burlesque_roles.rb",          "db/migrate/#{get_next_migration_number}_create_burlesque_roles.rb"
        copy_file "create_burlesque_authorizations.rb", "db/migrate/#{get_next_migration_number}_create_burlesque_authorizations.rb"
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
    end
  end
end