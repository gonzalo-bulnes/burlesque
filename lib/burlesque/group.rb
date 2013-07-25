require 'active_support/concern'

# encoding: utf-8

# Public: Modelo que maneja Grupos
#
module Burlesque
  module Group
    extend ActiveSupport::Concern

    included do
      has_many :role_groups
      has_many :roles, through: :role_groups, dependent: :destroy, after_remove: :remove_roles_from_admin

      has_many :admin_groups, dependent: :destroy
      # for has_many :admins relations see admins function

      attr_accessible :name, :role_ids, :internal

      validates :name, presence: true, uniqueness: true
    end

    module InstanceMethods
      # Public: Relacion a muchos usuarios
      #
      # Se usa esta funcion dado que la tabla de administrador es polimorfica.
      #
      # Returns los administradores que tienen el rol en cuestion.
      def admins
        admin_groups.map &:adminable
      end

      # Public: Indica si el grupo tiene un rol en particular.
      #
      # role -  el rol que se quiere consultar, puede ser un Role o Role.name
      #
      # Returns Boolean.
      def role? role
        role_name = role.respond_to?(:name) ? role.name : role
        self.roles.map(&:name).include?(role_name.to_s)
      end

      # Public: Setea los roles que se indican al grupo.
      # Eliminando los roles que no esten en la lista.
      #
      # ids - id's de los Roles que se desean asignar destructivamente.
      #
      # Returns nothing.
      def role_ids=(ids)
        ids.each do |ri|
          if ri.presence
            role = ::Role.find(ri)
            self.roles << role unless self.roles.include? role
          end
        end

        to_deletes = []
        role_groups.each do |rg|
          role = rg.role
          to_deletes << role unless ids.include?(role.id.to_s) or ids.include?(role.id)
        end

        to_deletes.each do |role|
          self.roles.delete(role) if self.roles.include?(role)
        end
      end

      # Public: Permite agregar un grupo de Roles al Grupo
      # No elimina los roles que no esten en la lista, solo agrega los que no estan.
      #
      # new_roles - el arreglo de roles que se quiere agregar al grupo
      #
      # Returns nothing.
      def push_roles new_roles
        new_roles.each do |role|
          self.roles << role unless self.roles.include? role
        end
      end

      private
      # Public: Permite que al eliminar un rol de un grupo, tambien se modifiquen los roles de los administradores asociados a ese grupo.
      #
      # role -  el rol que se elimino del grupo.
      #
      # Returns nothing.
      def remove_roles_from_admin role
        admins.each do |admin|
          if admin.authorizations.map(&:role_id).include?(role.id) and not admin.role_in_groups?(role.name)
            admin.authorizations.find_by_role_id(role.id).destroy
          end
        end
      end
    end
  end
end
