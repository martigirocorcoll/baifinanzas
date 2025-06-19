class CreateInfluencers < ActiveRecord::Migration[7.2]
  def change
    create_table :influencers do |t|
      t.string :name
      t.string :ac_compte
      t.string :ac_cdiposit
      t.string :ac_curt
      t.string :ac_llarg
      t.string :ac_deute
      t.string :ac_jubil

      t.timestamps
    end
    add_index :influencers, :ac_compte
  end
end
