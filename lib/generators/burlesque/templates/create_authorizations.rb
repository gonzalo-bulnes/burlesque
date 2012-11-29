class CreateBurlesqueAuthorizations < ActiveRecord::Migration
  def change
    create_table :burlesque_authorizations do |t|
      t.references  :burlesque_role
      t.integer     :authorizable_id
      t.string      :authorizable_type

      t.timestamps
    end
    add_index :burlesque_authorizations, :burlesque_role_id
    add_index :burlesque_authorizations, [:authorizable_id, :authorizable_type], name: 'by_authorizable'
  end
end
