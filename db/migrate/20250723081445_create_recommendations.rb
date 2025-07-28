class CreateRecommendations < ActiveRecord::Migration[7.2]
  def change
    create_table :recommendations do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.text :content
      t.string :video_url
      t.string :image_url
      t.string :category
      t.boolean :active

      t.timestamps
    end
    add_index :recommendations, :slug, unique: true
  end
end
