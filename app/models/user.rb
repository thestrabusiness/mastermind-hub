class User < ApplicationRecord
  include Clearance::User

  has_many :memberships
  has_many :commitments, through: :memberships
  has_many :groups, through: :memberships
  has_many :created_groups, class_name: 'Group', foreign_key: :creator_id

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_plus_initial
    "#{first_name} #{last_name[0]}."
  end

  def in_group?(group)
    groups.includes(group)
  end

  def initials
    "#{first_name[0]}#{last_name[0]}".upcase
  end
end
