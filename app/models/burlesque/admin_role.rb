# encoding: utf-8

# Public: Modelo intermedio, permite que un Role pueda ser asignado a un 'Administrador',
#         Este administrador puede ser cualquier modelo que incluya el modulo 'Burlesque::Admin'
#
module Burlesque
  class AdminRole < ActiveRecord::Base
    belongs_to :role
    belongs_to :authorizable, polymorphic: true

    validates_uniqueness_of :role_id, scope: [:authorizable_id, :authorizable_type], message: I18n.t('errors.messages.role_taken')
  end
end
