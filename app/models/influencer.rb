class Influencer < ApplicationRecord
  # Owner: the User account that manages this influencer profile
  belongs_to :user, optional: true

  # Referred users: users who signed up with this influencer's code
  has_many :users

  # Validations
  validates :name, presence: true

  # Callbacks
  after_create :generate_unique_code

  # Class method to get default influencer
  def self.default_influencer
    find_by(default: true)
  end

  # Instance method to set this influencer as default
  def set_as_default!
    # Remove default from all other influencers
    Influencer.where(default: true).update_all(default: false)
    # Set this one as default
    update!(default: true)
  end

  # Instance method to remove default status
  def remove_default!
    update!(default: false)
  end

  private

  def generate_unique_code
    # Generate unique short code: 8 random characters
    # Example: "cc69900c"
    return if code.present? # Skip if code already exists

    self.code = SecureRandom.hex(4)

    save if changed?
  end
end
