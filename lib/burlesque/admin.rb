require 'active_support/concern'

# Public: Modulo para manejar logica de Administradores con Grupos y Roles,
#         permite que los GRupos y Roles puedan ser asignado a un 'Administrador',
#         y este 'Administrador' puede ser cualquier modelo que incluya este modulo
#
module Burlesque
  module Admin
    extend ActiveSupport::Concern

    included do
      has_many        :admin_roles,      as: :authorizable, dependent: :destroy, class_name: Burlesque::AdminRole
      has_many        :roles,       through: :admin_roles, class_name: Burlesque::Role

      has_many        :admin_groups,      as: :adminable,       dependent: :destroy, class_name: Burlesque::AdminGroup
      has_many        :groups,       through: :admin_groups, after_remove: :remove_roles_from_admin, class_name: Burlesque::Group
    end

    module InstanceMethods
      # Public: Indica si tiene un rol en particular.
      #
      # role -  el rol que se quiere consultar, puede ser un Role o Role.name
      #
      # Returns Boolean.
      def role? role
        role_name = role.respond_to?(:name) ? role.name : role
        self.roles.map(&:name).include?(role_name.to_s)
      end

      # Public: Indica si tiene un grupo en particular.
      #
      # group -  el grupo que se quiere consultar, puede ser un Group o Group.name
      #
      # Returns Boolean.
      def group? group
        group_name = group.respond_to?(:name) ? group.name : group
        self.groups.map(&:name).include?(group_name.to_s)
      end

      # Public: Indica si un rol en particular esta presente en los grupos que tiene asignados.
      #
      # role -  el rol que se quiere consultar, puede ser un Role o Role.name
      #
      # Returns Boolean.
      def role_in_groups? role
        role_name = role.respond_to?(:name) ? role.name : role
        groups.each do |group|
          return true if group.role?(role_name)
        end
        false
      end

      # Public: Permite setear los grupos que se indican.
      # Eliminando los grupos que no esten en la lista.
      #
      # ids - id's de los Grupos que se desean asignar destructivamente.
      #
      # Returns nothing.
      def group_ids=(ids)
        ids.each do |group_id|
          if group_id.presence
            group = ::Burlesque::Group.find(group_id)
            self.groups << group unless self.groups.include?(group)
          end
        end

        to_deletes = []
        self.groups.each do |group|
          to_deletes << group unless ids.include?(group.id) or ids.include?(group.id.to_s)
        end

        to_deletes.each do |group|
          self.groups.delete(group) if self.group?(group)
        end
      end

      # Public: Permite setear los roles que se indican.
      # Eliminando los roles que no esten en la lista,
      # salvo en caso de estar presente por asignacion de un grupo.
      #
      # ids - id's de los Roles que se desean asignar destructivamente.
      #
      # Returns nothing.
      def role_ids=(ids)
        ids.each do |role_id|
          if role_id.presence
            role = ::Burlesque::Role.find(role_id)
            self.roles << role unless self.role?(role)
          end
        end

        to_deletes = []
        self.roles.each do |role|
          to_deletes << role unless ids.include?(role.id) or ids.include?(role.id.to_s) or self.role_in_groups?(role)
        end

        to_deletes.each do |role|
          self.roles.delete(role) if self.roles.include?(role)
        end
      end

      private
      # Public: Permite eliminar los roles de un grupo eliminado.
      #
      # group - El grupo que se elimino.
      #
      # Returns nothing.
      def remove_roles_from_admin group
        group.roles.each do |role|
          if admin_roles.map(&:role).include?(role) and not role_in_groups?(role.name)
            admin_roles.find_by_role_id(role.id).destroy
          end
        end
      end
    end
  end
end
