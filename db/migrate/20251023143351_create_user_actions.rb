class CreateUserActions < ActiveRecord::Migration[7.2]
  def change
    create_table :user_actions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action_type
      t.string :action_key
      t.datetime :completed_at

      t.timestamps
    end
  end
end
