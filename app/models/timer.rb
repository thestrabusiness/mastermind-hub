class Timer < ApplicationRecord
  DURATION_RANGE = Array(1..60)
  belongs_to :facilitator, class_name: 'User'
  belongs_to :user

  validates :facilitator, presence: true
  validate :facilitator_role
  validates :user, presence: true

  def self.duration_select_options
    DURATION_RANGE.map { |minutes| [minutes, minutes * 60] }
  end

  def ends_at
    created_at + duration
  end

  private

  def facilitator_role
    facilitator.role == User::FACILITATOR
  end
end
