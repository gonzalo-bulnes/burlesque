require 'rails/generators/migration'
require 'thor/shell/basic.rb'

module Burlesque
  module Generators
    class BurlesqueGenerator < Rails::Generators::Base
      argument :attributes, :type => :array, :default => []

      def inject_burlesque_content
        content = <<-CONTENT
  include Burlesque::Admin
CONTENT

        puts "#{attributes.inspect}"
        inject_into_class(File.join("app", "models", "#{class_name}.rb"), class_name, content)
      end
    end
  end
end