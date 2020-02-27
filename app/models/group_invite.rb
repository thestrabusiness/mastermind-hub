class GroupInvite < ApplicationRecord
  after_initialize :generate_token, if: :new_record?

  belongs_to :group

  scope :unaccepted, -> { where(accepted: false) }

  private

  def generate_token
    self.token = SecureRandom.hex
  end
end
