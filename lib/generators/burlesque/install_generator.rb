require 'rails/generators/migration'
require 'thor/shell/basic.rb'

module Burlesque
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def copy_model_and_migration
        ######## Role #######
        # Crea el modelo Role
        copy_file "role.rb", "app/models/role.rb"

        # Crea la tabla del modelo
        if not role = Dir.glob("db/migrate/[0-9]*_*.rb").grep(/\d+_create_roles.rb$/).first
          migration_template  "create_roles.rb", "db/migrate/create_roles.rb"
        else
          puts "#{role}"
          Thor::Shell::Basic.new.say_status :exist, role, :blue
        end

        ######## Authorization #######
        # Crea el modelo Authorization
        copy_file "authorization.rb", "app/models/authorization.rb"

        # Crea la tabla del modelo
        if not authorization = Dir.glob("db/migrate/[0-9]*_*.rb").grep(/\d+_create_authorizations.rb$/).first
          migration_template  "create_authorizations.rb", "db/migrate/create_authorizations.rb"
        else
          puts "#{authorization}"
          Thor::Base.shell.say_status :exist, role, :blue
        end
      end


      def self.next_migration_number path
        # unless @prev_migration_nr
        #   @prev_migration_nr = Dir.glob("#{Rails.root}/db/migrate/[0-9]*_*.rb").inject(0) do |max, file_path|
        #     n = File.basename(file_path).split('_', 2).first.to_i
        #     if n > max then n else max end
        #   end
        # else
        #   @prev_migration_nr += 1
        # end

        # ActiveRecord::Migration.new.next_migration_number(@prev_migration_nr.to_s)

        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
    end
  end
end