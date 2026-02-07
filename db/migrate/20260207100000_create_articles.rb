class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.text :excerpt
      t.text :body
      t.string :category
      t.integer :read_time, default: 5
      t.string :author, default: "BaiFinanzas"
      t.datetime :published_at
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :articles, :slug, unique: true
    add_index :articles, :category
    add_index :articles, :active
    add_index :articles, :published_at
  end
end
