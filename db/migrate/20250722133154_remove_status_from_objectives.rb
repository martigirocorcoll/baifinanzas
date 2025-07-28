class RemoveStatusFromObjectives < ActiveRecord::Migration[7.2]
  def change
    remove_column :objectives, :status, :string
  end
end
