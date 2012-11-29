class CreateRoleGroups < ActiveRecord::Migration
  def change
    create_table :role_groups do |t|
      t.references :role
      t.references :group

      t.timestamps
    end
    add_index :role_groups, :role_id
    add_index :role_groups, :group_id
  end
end
