module Burlesque
  module Role
    has_many :role_groups
    has_many :groups, through: :role_groups, dependent: :destroy

    has_many :authorizations, dependent: :destroy
    def admins
      authorizations.map &:authorizable
    end

    attr_accessible :name
    validates :name, presence: true, uniqueness: true


    scope :action,        lambda { |action| where('name LIKE ?',                          "#{action}_%") }
    scope :not_action,    lambda { |action| where('name NOT LIKE ?',                      "#{action}_%") }
    scope :resource,      lambda { |model|  where('name LIKE ? or name LIKE ?',           "%_#{model.to_s.singularize}", "%_#{model.to_s.pluralize}") }
    scope :not_resource,  lambda { |model|  where('name NOT LIKE ? AND name NOT LIKE ?',  "%_#{model.to_s.singularize}", "%_#{model.to_s.pluralize}") }


    # Public: Traduce el nombre de un rol.
    #
    # Returns el nombre del rol ya traducido.
    def translate_name
      translate = I18n.t(name.to_sym, scope: :authorizations)
      return translate unless translate.include?('translation missing:')


      action = name.split('_', 2).first
      model  = name.split('_', 2).last

      count  = model == model.pluralize ? 2 : 1
      model = model.pluralize

      translate = I18n.t(action.to_sym, scope: :authorizations) + ' ' + model.classify.constantize.model_name.human(count: count)
    end

    def self.for model
      if model.class == String
        resource = model.classify.constantize.model_name.underscore
      elsif model.class == Symbol
        resource = model.to_s.classify.constantize.model_name.underscore
      elsif model.class == Class
        resource = model.model_name.underscore
      end

      if resource
        Role.create(name:    "read_#{resource.pluralize}") unless Role.where(name:    "read_#{resource.pluralize}").any?
        Role.create(name:    "show_#{resource}")           unless Role.where(name:    "show_#{resource}").any?
        Role.create(name:  "create_#{resource}")           unless Role.where(name:  "create_#{resource}").any?
        Role.create(name:  "update_#{resource}")           unless Role.where(name:  "update_#{resource}").any?
        Role.create(name: "destroy_#{resource}")           unless Role.where(name: "destroy_#{resource}").any?
      else
        raise I18n.t('errors.messages.invalid_param', param: model.class)
      end
    end
  end
end
