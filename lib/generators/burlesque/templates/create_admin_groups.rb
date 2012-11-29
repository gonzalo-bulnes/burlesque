class CreateAdminGroups < ActiveRecord::Migration
  def change
    create_table :admin_groups do |t|
      t.references  :group
      t.integer     :adminable_id
      t.string      :adminable_type

      t.timestamps
    end
    add_index :admin_groups, :group_id
    add_index :admin_groups, [:adminable_id, :adminable_type], name: 'by_adminable'
  end
end
