# encoding: utf-8

# Public: Modulo que maneja Roles.
#         Un Role es un permiso que permite a un usuario a realizar una determinada acción sobre un modelo
#
module Burlesque
  class Role < ActiveRecord::Base
    attr_accessible :name

    has_many :role_groups
    has_many :groups, through: :role_groups, dependent: :destroy

    has_many :admin_roles, dependent: :destroy
    # for has_many :admins relations see admins function

    attr_accessible :name
    validates :name, presence: true, uniqueness: true

    SPLITER = '#'

    scope :action,        lambda { |action| where('name LIKE ?',     "%#{SPLITER}#{action}")                }
    scope :not_action,    lambda { |action| where('name NOT LIKE ?', "%#{SPLITER}#{action}")                }
    scope :resource,      lambda { |model|  where('name LIKE ?',     "#{model.to_s.underscore}#{SPLITER}%") }
    scope :not_resource,  lambda { |model|  where('name NOT LIKE ?', "#{model.to_s.underscore}#{SPLITER}%") }

    # Public: Relacion a muchos usuarios
    #
    # Se usa esta funcion dado que la tabla de administrador es polimorfica.
    #
    # Returns los administradores que tienen el rol en cuestion.
    def admins
      admin_roles.map &:authorizable
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

      begin
        translate = I18n.t(action_sym, scope: :authorizations) + ' ' + resource_class.model_name.human
      rescue
        translate = I18n.t(action_sym, scope: :authorizations) + ' ' + resource_class.to_s
      end

      return translate unless translate.include?('translation missing:')
      return name
    end

    # Public: Entrega el recurso asociado al rol.
    #
    # Returns Constant.
    def resource_class
      model_name = name.split('#', 2).first
      begin
        model_name.pluralize.classify.constantize
      rescue
        model_name.to_sym
      end
    end

    # Public: Entrega la accion asociada al rol.
    #
    # Returns Symbol.
    def action_sym
      name.split('#', 2).last.to_sym
    end

    # Public: Entrega la accion y modelo asociado al rol.
    #
    # Returns Symbol.
    def get_action_and_model
      [action_sym, resource_class]
    end

    # TODO
    # Mejorar el retorno, para saber que paso, ej: si se agregaron los 5 roles o si ya existen
    def self.for model
      if model.class == String
        resource = model.classify.constantize.model_name.underscore
      elsif model.class == Symbol
        resource = model.to_s.classify.constantize.model_name.underscore
      elsif model.class == Class
        resource = model.model_name.underscore
      end

      if resource
        self.create(name: "#{resource}#{SPLITER}read")     unless self.where(name: "#{resource}#{SPLITER}read"   ).any?
        self.create(name: "#{resource}#{SPLITER}create")   unless self.where(name: "#{resource}#{SPLITER}create" ).any?
        self.create(name: "#{resource}#{SPLITER}update")   unless self.where(name: "#{resource}#{SPLITER}update" ).any?
        self.create(name: "#{resource}#{SPLITER}destroy")  unless self.where(name: "#{resource}#{SPLITER}destroy").any?
      else
        raise I18n.t('errors.messages.invalid_param', param: model.class)
      end
    end
  end
end
