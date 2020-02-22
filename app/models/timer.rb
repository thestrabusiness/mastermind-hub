class Timer < ApplicationRecord
  belongs_to :facilitator, class_name: 'User'
  belongs_to :user

  validates :facilitator, presence: true
  validate :facilitator_role
  validates :user, presence: true

  private

  def facilitator_role
    facilitator.role == User::FACILITATOR
  end
end
