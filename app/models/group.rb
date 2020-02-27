class Group < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :memberships
  has_many :users, through: :memberships
  has_many :timers

  validates :name, presence: true

  def facilitator
    memberships.find_by(role: Membership::FACILITATOR)&.user
  end
end
