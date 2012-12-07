module Burlesque
  module Group
    has_many :role_groups
    has_many :roles, through: :role_groups, dependent: :destroy, after_remove: :remove_roles_from_admin

    has_many :admin_groups, dependent: :destroy
    def admins
      admin_groups.map &:adminable
    end

    attr_accessible :name, :role_ids

    validates :name, presence: true, uniqueness: true

    # Public: Indica si el grupo tiene un rol en particular.
    #
    # name  - el nombre del rol que se quiere consultar.
    #
    # Returns Boolean.
    def role? name
      self.roles.map(&:name).include?(name.to_s)
    end

    def role_ids=(ids)
      ids.each do |ri|
        role = Role.find(ri)
        self.roles << role unless self.roles.include? role
      end

      to_deletes = []
      role_groups.each do |rg|
        role = rg.role
        to_deletes << role unless ids.include?(role.id.to_s) or ids.include?(role.id)
      end

      to_deletes.each do |role|
        self.roles.delete(role) if self.roles.include?(role)
      end
    end

    def push_roles new_roles
      new_roles.each do |role|
        self.roles << role unless self.roles.include? role
      end
    end

    private
    # Public: Permite que al eliminar un rol de un grupo, tambien se modifiquen los roles de los administradores asociados a ese grupo.
    #
    # role  - El rol que se elimino del grupo.
    #
    # Returns nothing.
    def remove_roles_from_admin role
      admins.each do |admin|
        if admin.authorizations.map(&:role_id).include?(role.id) and not admin.role_in_groups?(role.name)
          admin.authorizations.find_by_role_id(role.id).destroy
        end
      end
    end
  end
end
