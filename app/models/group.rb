class Group < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :facilitator, class_name: 'User'
  has_many :timers

  validates :name, presence: true
  validates :facilitator, presence: true
  validate :facilitator_role

  private

  def facilitator_role
    facilitator.role == User::FACILITATOR
  end
end
