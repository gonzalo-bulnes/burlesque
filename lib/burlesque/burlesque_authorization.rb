module Burlesque
  module BurlesqueAuthorization
    belongs_to :burlesque_role
    belongs_to :authorizable, polymorphic: true

    validates_uniqueness_of :role_id, scope: [:authorizable_id, :authorizable_type], message: I18n.t('errors.messages.role_taken')
  end
end
