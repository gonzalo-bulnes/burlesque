class CreateBurlesqueAdminRoles < ActiveRecord::Migration
  def change
    create_table :burlesque_admin_roles do |t|
      t.references  :role

      t.integer     :authorizable_id
      t.string      :authorizable_type

      t.timestamps
    end

    add_index :burlesque_admin_roles, :role_id
    add_index :burlesque_admin_roles, [:authorizable_id, :authorizable_type], name: 'by_authorizable'
  end
end
