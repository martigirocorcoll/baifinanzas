class UserAction < ApplicationRecord
  belongs_to :user

  # Scopes
  scope :completed, -> { where.not(completed_at: nil) }
  scope :for_recommendation, ->(key) { where(action_type: 'recommendation', action_key: key) }
  scope :for_objective, ->(objective_id) { where(action_type: 'objective', action_key: objective_id.to_s) }

  # Métodos
  def completed?
    completed_at.present?
  end

  def mark_completed!
    update(completed_at: Time.current) unless completed?
  end
end
