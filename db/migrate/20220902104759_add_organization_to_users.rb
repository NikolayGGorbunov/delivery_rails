class AddOrganizationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :organization, foreign_key: true
    add_column :users, :role, :string, null: false, default: 'operator'
  end
end
