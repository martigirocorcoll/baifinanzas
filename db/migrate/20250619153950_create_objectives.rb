class CreateObjectives < ActiveRecord::Migration[7.2]
  def change
    create_table :objectives do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :target_amount
      t.date :target_date
      t.string :status

      t.timestamps
    end
  end
end
