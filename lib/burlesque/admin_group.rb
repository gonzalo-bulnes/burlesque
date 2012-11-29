module Burlesque
  module AdminGroup
    belongs_to :group
    belongs_to :adminable, polymorphic: true

    validates_uniqueness_of :group_id, scope: [:adminable_id, :adminable_type], message: I18n.t('errors.messages.group_taken')


    after_create :add_new_roles_to_admin

    private
    def add_new_roles_to_admin
      group.roles.each do |role|
        adminable.roles << role unless adminable.roles.include? role
      end
    end
  end
end
