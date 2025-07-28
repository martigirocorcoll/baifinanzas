class AddTaxAdvisoryToInfluencers < ActiveRecord::Migration[7.2]
  def change
    add_column :influencers, :ac_fiscal, :string
  end
end
