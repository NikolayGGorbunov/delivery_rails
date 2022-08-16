# frozen_string_literal: true

class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :first_name, null: false
      t.string :second_name, null: false
      t.string :third_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.float :weight, null: false
      t.integer :length, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.string :start_point, null: false
      t.string :end_point, null: false
      t.integer :distance, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
