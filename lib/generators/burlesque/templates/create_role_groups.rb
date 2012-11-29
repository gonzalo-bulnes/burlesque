class CreateBurlesqueRoleBurlesqueGroups < ActiveRecord::Migration
  def change
    create_table :burlesque_role_burlesque_groups do |t|
      t.references :burlesque_role
      t.references :burlesque_group

      t.timestamps
    end
    add_index :burlesque_role_burlesque_groups, :burlesque_role_id
    add_index :burlesque_role_burlesque_groups, :burlesque_group_id
  end
end
