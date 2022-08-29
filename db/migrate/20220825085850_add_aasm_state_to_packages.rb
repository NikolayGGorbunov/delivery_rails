class AddAasmStateToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :aasm_state, :string
  end
end
