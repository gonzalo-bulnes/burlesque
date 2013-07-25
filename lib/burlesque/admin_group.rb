require 'active_support/concern'

# encoding: utf-8

# Public: Modelo intermedio, permite que un Grupo pueda ser asignado a un 'Administrador',
#         Este administrador puede ser cualquier modelo que incluya el modulo 'Burlesque::Admin'
#
module Burlesque
  module AdminGroup
    extend ActiveSupport::Concern

    included do
      belongs_to :group
      belongs_to :adminable, polymorphic: true

      validates_uniqueness_of :group_id, scope: [:adminable_id, :adminable_type], message: I18n.t('errors.messages.group_taken')

      after_create :add_new_roles_to_admin
    end

    module InstanceMethods
      private
      def add_new_roles_to_admin
        group.roles.each do |role|
          adminable.roles << role unless adminable.roles.include? role
        end
      end
    end
  end
end
