class User < ApplicationRecord
  include Clearance::User

  has_many :memberships
  has_many :groups, through: :memberships
  has_many :created_groups, class_name: 'Group', foreign_key: :creator_id

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_plus_initial
    "#{first_name} #{last_name[0]}."
  end

  def self.select_options
    all.map { |user| [user.full_name, user.id] }
  end
end
