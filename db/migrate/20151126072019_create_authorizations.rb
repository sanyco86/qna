class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end
    add_index :authorizations, [:provider, :uid]
    add_foreign_key :authorizations, :users
  end
end