require 'active_support/concern'

# encoding: utf-8

# Public: Modelo intermedio, permite que un Role pueda ser asignado a un 'Administrador',
#         Este administrador puede ser cualquier modelo que incluya el modulo 'Burlesque::Admin'
#
module Burlesque
  module Authorization
    extend ActiveSupport::Concern

    included do
      belongs_to :role
      belongs_to :authorizable, polymorphic: true

      validates_uniqueness_of :role_id, scope: [:authorizable_id, :authorizable_type], message: I18n.t('errors.messages.role_taken')
    end
  end
end
