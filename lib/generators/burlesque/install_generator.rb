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
          Thor::Shell::Basic.new.say_status :exist, role, :blue
        end

        ######## Authorization #######
        # Crea el modelo Authorization
        copy_file "authorization.rb", "app/models/authorization.rb"

        # Crea la tabla del modelo
        if not authorization = Dir.glob("db/migrate/[0-9]*_*.rb").grep(/\d+_create_authorizations.rb$/).first
          migration_template  "create_authorizations.rb", "db/migrate/create_authorizations.rb"
        else
          Thor::Shell::Basic.new.say_status :exist, authorization, :blue
        end

        ######## Group #######
        # Crea el modelo Group
        copy_file "group.rb", "app/models/group.rb"

        # Crea la tabla del modelo
        if not group = Dir.glob("db/migrate/[0-9]*_*.rb").grep(/\d+_create_groups.rb$/).first
          migration_template  "create_groups.rb", "db/migrate/create_groups.rb"
        else
          Thor::Shell::Basic.new.say_status :exist, group, :blue
        end

        ######## Role-Group #######
        # Crea el modelo Role-Group
        copy_file "role_group.rb", "app/models/role_group.rb"

        # Crea la tabla del modelo
        if not role_group = Dir.glob("db/migrate/[0-9]*_*.rb").grep(/\d+_create_role_groups.rb$/).first
          migration_template  "create_role_groups.rb", "db/migrate/create_role_groups.rb"
        else
          Thor::Shell::Basic.new.say_status :exist, role_group, :blue
        end

        ######## Admin-Group #######
        # Crea el modelo Admin-Group
        copy_file "admin_group.rb", "app/models/admin_group.rb"

        # Crea la tabla del modelo
        if not admin_group = Dir.glob("db/migrate/[0-9]*_*.rb").grep(/\d+_create_admin_groups.rb$/).first
          migration_template  "create_admin_groups.rb", "db/migrate/create_admin_groups.rb"
        else
          Thor::Shell::Basic.new.say_status :exist, admin_group, :blue
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