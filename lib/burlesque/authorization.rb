module Burlesque
  module Authorization
    belongs_to :role
    belongs_to :authorizable, polymorphic: true

    validates_uniqueness_of :role_id, scope: [:authorizable_id, :authorizable_type], message: I18n.t('errors.messages.role_taken')
  end
end
