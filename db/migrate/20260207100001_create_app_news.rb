class CreateAppNews < ActiveRecord::Migration[7.2]
  def change
    create_table :app_news do |t|
      t.string :title, null: false
      t.text :content
      t.datetime :published_at
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :app_news, :active
    add_index :app_news, :published_at
  end
end
