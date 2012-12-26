require 'rails/generators/active_record'
require 'thor/shell/basic.rb'

module ActiveRecord
  module Generators
    class BurlesqueGenerator < ActiveRecord::Generators::Base
      argument :attributes, :type => :array, :default => []

      def inject_burlesque_content
        content = <<-CONTENT
  include Burlesque::Admin
CONTENT

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"


        puts "#{attributes.inspect}"
        inject_into_class(model_path, class_path.last, content) if File.exists?(File.join(destination_root, model_path))
      end
    end
  end
end