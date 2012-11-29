class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references  :role
      t.integer     :authorizable_id
      t.string      :authorizable_type

      t.timestamps
    end
    add_index :authorizations, :role_id
    add_index :authorizations, [:authorizable_id, :authorizable_type], name: 'by_authorizable'
  end
end
