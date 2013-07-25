require 'active_support/concern'

# encoding: utf-8

# Public: Modulo intermedio, permite que un Role pueda ser asignado a un Grupo
#
module Burlesque
  module RoleGroup
    extend ActiveSupport::Concern

    included do
      belongs_to :role
      belongs_to :group

      validates_uniqueness_of :role_id, scope: :group_id, message: I18n.t('errors.messages.role_taken')

      after_save :add_new_roles_to_admin
    end


    module InstanceMethods
      private

      # Public: Actualiza los roles de los administradores luego de haber actualizado el grupo de roles.
      #
      # Returns nothing.
      def add_new_roles_to_admin
        group.admins.each do |admin|
          admin.roles << self.role unless admin.roles.include?(self.role)
        end
      end
    end
  end
end
