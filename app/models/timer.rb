class Timer < ApplicationRecord
  belongs_to :facilitator, class_name: 'User'
  belongs_to :user

  validates :facilitator, presence: true
  validates :user, presence: true
end
