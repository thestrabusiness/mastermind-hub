# frozen_string_literal: true

class GroupInvite < ApplicationRecord
  after_initialize :generate_token, if: :new_record?

  belongs_to :group

  scope :unaccepted, -> { where(accepted: false) }

  validate :user_not_already_in_group, on: :create

  private

  def user_not_already_in_group
    return unless group.users.where(email: email).exists?

    errors.add(:group, "Can't send an invite to an existing member")
  end

  def generate_token
    self.token = SecureRandom.hex
  end
end
