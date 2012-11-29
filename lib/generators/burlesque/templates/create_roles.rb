class CreateBurlesqueRoles < ActiveRecord::Migration
  def change
    create_table :burlesque_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
