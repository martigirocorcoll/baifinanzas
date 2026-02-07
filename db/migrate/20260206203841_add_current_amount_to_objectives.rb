class AddCurrentAmountToObjectives < ActiveRecord::Migration[7.2]
  def change
    add_column :objectives, :current_amount, :integer, default: 0, null: false
  end
end
