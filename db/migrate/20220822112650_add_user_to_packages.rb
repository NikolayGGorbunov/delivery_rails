class AddUserToPackages < ActiveRecord::Migration[7.0]
  def change
    add_reference :packages, :user, null: false, foreign_key: true
  end
end
