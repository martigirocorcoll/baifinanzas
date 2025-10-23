class AddDeviseAndVideosToInfluencers < ActiveRecord::Migration[7.2]
  def change
    # Devise fields
    add_column :influencers, :email, :string, null: false, default: ""
    add_column :influencers, :encrypted_password, :string, null: false, default: ""
    add_column :influencers, :reset_password_token, :string
    add_column :influencers, :reset_password_sent_at, :datetime
    add_column :influencers, :remember_created_at, :datetime

    # Unique code for referral tracking
    add_column :influencers, :code, :string

    # Video URLs (8 fields)
    add_column :influencers, :video_compte, :string
    add_column :influencers, :video_cdiposit, :string
    add_column :influencers, :video_curt, :string
    add_column :influencers, :video_llarg, :string
    add_column :influencers, :video_deute, :string
    add_column :influencers, :video_jubil, :string
    add_column :influencers, :video_fiscal, :string
    add_column :influencers, :video_portfolio, :string

    # Indexes
    add_index :influencers, :email, unique: true
    add_index :influencers, :reset_password_token, unique: true
    add_index :influencers, :code, unique: true
  end
end
