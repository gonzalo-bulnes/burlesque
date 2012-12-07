class RoleGroup < ActiveRecord::Base
  belongs_to :role
    belongs_to :group

    validates_uniqueness_of :role_id, scope: :group_id, message: I18n.t('errors.messages.role_taken')

    after_save :add_new_roles_to_admin

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