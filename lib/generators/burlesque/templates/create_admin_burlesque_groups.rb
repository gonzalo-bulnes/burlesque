class CreateAdminBurlesqueGroups < ActiveRecord::Migration
  def change
    create_table :admin_burlesque_groups do |t|
      t.references  :burlesque_group
      t.integer     :adminable_id
      t.string      :adminable_type

      t.timestamps
    end
    add_index :admin_burlesque_groups, :group_id
    add_index :admin_burlesque_groups, [:adminable_id, :adminable_type], name: 'by_adminable'
  end
end
