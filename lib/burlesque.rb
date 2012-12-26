# require "burlesque/admin_group"
# require "burlesque/authorization"
# require "burlesque/group"
require "burlesque/role"
# require "burlesque/role_group"
require "burlesque/version"

module Burlesque
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'rails-i18n' do |app|
      I18n.load_path << Dir[File.join(File.expand_path(File.dirname(__FILE__) + '/../config/locales'), '*.yml')]
      I18n.load_path.flatten!
    end
  end
end