class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :influencer, optional: true

  has_one  :pyg,     dependent: :destroy
  has_one  :balance, dependent: :destroy
  has_many :objectives, dependent: :destroy

  # Create default PYG and Balance after user signup
  after_create :build_default_financials

  private

  def build_default_financials
    create_pyg
    create_balance
  end
end
