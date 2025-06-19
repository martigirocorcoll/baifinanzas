class Objective < ApplicationRecord
  belongs_to :user

  validates :title, :target_amount, :target_date, presence: true
  validates :target_amount, numericality: { only_integer: true, greater_than: 0 }
  validates :status, inclusion: { in: %w[pending active completed cancelled] }
end
