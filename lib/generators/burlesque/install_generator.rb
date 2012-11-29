module Burlesque
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_models
        copy_file "burlesque_role.rb",          "app/models/burlesque_role.rb"
        copy_file "burlesque_authorization.rb", "app/models/burlesque_authorization.rb"
      end
    end
  end
end