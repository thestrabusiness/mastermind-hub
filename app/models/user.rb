# frozen_string_literal: true

class User < ApplicationRecord
  include Clearance::User

  validates :first_name, :last_name, presence: true

  has_many :memberships
  has_many :commitments, through: :memberships
  has_many :groups, through: :memberships
  has_many :created_groups, class_name: "Group", foreign_key: :creator_id

  scope :receives_reminders, -> { where(receive_reminder_email: true) }

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
