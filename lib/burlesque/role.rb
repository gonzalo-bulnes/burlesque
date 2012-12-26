require 'active_support/concern'

module Burlesque
  module Role
    extend ActiveSupport::Concern

    included do
      has_many :role_groups
      has_many :groups, through: :role_groups, dependent: :destroy

      has_many :authorizations, dependent: :destroy
      # for has_many :admins relations see admins function

      attr_accessible :name
      validates :name, presence: true, uniqueness: true


      scope :action,        lambda { |action| where('name LIKE ?',                          "#{action}_%") }
      scope :not_action,    lambda { |action| where('name NOT LIKE ?',                      "#{action}_%") }
      scope :resource,      lambda { |model|  where('name LIKE ? or name LIKE ?',           "%_#{model.to_s.singularize}", "%_#{model.to_s.pluralize}") }
      scope :not_resource,  lambda { |model|  where('name NOT LIKE ? AND name NOT LIKE ?',  "%_#{model.to_s.singularize}", "%_#{model.to_s.pluralize}") }
    end

    module InstanceMethods
      # Public: Relacion a muchos usuarios
      #
      # Se usa esta funcion dado que la tabla de administrador es polimorfica.
      #
      # Returns los administradores que tienen el rol en cuestion.
      def admins
        authorizations.map &:authorizable
      end

      # Public: Traduce el nombre de un rol.
      #
      # Primero revisa si existe una traducción para el rol bajo el scope de autorizaciones,
      # luego si el no existe una traducción intenta traducir el nombre del rol usando la
      # traduccion de Burleque, que traduce la acción por defecto e intenta usar las traducciones
      # definidas para cada modelo
      #
      # Returns el nombre del rol ya traducido.
      def translate_name
        translate = I18n.t(name.to_sym, scope: :authorizations)
        return translate unless translate.include?('translation missing:')


        action, model = name.split('_', 2)

        count = (model == model.pluralize) ? 2 : 1
        model = model.pluralize

        translate = I18n.t(action.to_sym, scope: :authorizations) + ' ' + model.classify.constantize.model_name.human(count: count)
      end
    end

    module ClassMethods
      # TODO
      # Mejorar el retorno, para saber que paso, ej: si se agregaron los 5 roles o si ya existen
      def for model
        if model.class == String
          resource = model.classify.constantize.model_name.underscore
        elsif model.class == Symbol
          resource = model.to_s.classify.constantize.model_name.underscore
        elsif model.class == Class
          resource = model.model_name.underscore
        end

        if resource
          self.create(name:    "read_#{resource.pluralize}") unless self.where(name:    "read_#{resource.pluralize}").any?
          self.create(name:    "show_#{resource}")           unless self.where(name:    "show_#{resource}").any?
          self.create(name:  "create_#{resource}")           unless self.where(name:  "create_#{resource}").any?
          self.create(name:  "update_#{resource}")           unless self.where(name:  "update_#{resource}").any?
          self.create(name: "destroy_#{resource}")           unless self.where(name: "destroy_#{resource}").any?
        else
          raise I18n.t('errors.messages.invalid_param', param: model.class)
        end
      end

      def find id
        self.find id
      end
    end
  end
end
