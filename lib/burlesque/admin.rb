require 'active_support/concern'

module Burlesque
  module Admin
    extend ActiveSupport::Concern

    included do
      has_many  :authorizations, as: :authorizable, dependent: :destroy
      has_many  :roles, through: :authorizations

      has_many  :admin_groups, as: :adminable, dependent: :destroy
      has_many  :groups, through: :admin_groups, after_remove: :remove_roles_from_admin

      attr_accessible :group_ids, :role_ids

      validates :name, presence: true, uniqueness: true
    end

    module InstanceMethods
      def role? name
        self.roles.map(&:name).include?(name.to_s)
      end

      def role_in_groups? role
        groups.each do |group|
          return true if group.role?(role)
        end
        false
      end

      def group_ids=(ids)
        ids.each do |gi|
          group = Group.find(gi)
          self.groups << group unless self.groups.include?(group)
        end

        to_deletes = []
        admin_groups.each do |admin_group|
          group = admin_group.group
          to_deletes << group unless ids.include?(group.id.to_s)# or ids_roles.include?(rg.role_id)
        end

        to_deletes.each do |role|
          self.roles.delete(role) if self.roles.include?(role)
        end
      end

      def role_ids=(ids)
        # TODO
      end


      private
      # Public: Permite eliminar los roles de un grupo eliminado.
      #
      # group  - El grupo que se elimino.
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
