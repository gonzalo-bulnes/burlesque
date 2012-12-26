require 'active_support/concern'
require 'find'

module Burlesque
  module Admin
    extend ActiveSupport::Concern

    included do
      has_many        :authorizations,      as: :authorizable,    dependent: :destroy
      has_many        :roles,          through: :authorizations

      has_many        :admin_groups,        as: :adminable,       dependent: :destroy
      has_many        :groups,         through: :admin_groups, after_remove: :remove_roles_from_admin

      attr_accessible :group_ids,
                      :role_ids
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
      # ids - id's de los Roles que se desean asignar destructivamente.
      #
      # Returns nothing.
      def group_ids=(ids)
        ids.each do |gi|
          group = Group.find(gi)
          self.groups << group unless self.groups.include?(group)
        end

        to_deletes = []
        admin_groups.each do |admin_group|
          group = admin_group.group
          to_deletes << group unless ids.include?(group.id.to_s)# or ids.include?(group.id)
        end

        to_deletes.each do |role|
          self.roles.delete(role) if self.role?(role)
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
          role = Role.find(role_id)
          self.roles << role unless self.role?(role)
        end

        to_deletes = []
        self.roles.each do |role|
          to_deletes << role unless ids.include?(role.id.to_s) or self.role_in_groups?(role)# or ids.include?(role.id)
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
          if authorizations.map(&:role).include?(role) and not role_in_groups?(role.name)
            authorizations.find_by_role_id(role.id).destroy
          end
        end
      end
    end
  end
end
