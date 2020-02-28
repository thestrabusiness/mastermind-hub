class Group < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :memberships
  has_many :users, through: :memberships
  has_many :timers
  has_many :calls

  validates :name, presence: true

  def facilitator
    memberships.find_by(role: Membership::FACILITATOR)&.user
  end

  def user_select_options
    users.map { |user| [user.full_name, user.id] }
  end
end
