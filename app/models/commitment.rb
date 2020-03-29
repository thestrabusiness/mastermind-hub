class Commitment < ApplicationRecord
  belongs_to :membership
  belongs_to :call

  delegate :user, to: :membership

  validates :completed, inclusion: [true, false]
  with_options presence: true do
    validates :body
    validates :call, uniqueness: { scope: :membership }
    validates :membership
  end

  validate :membership_in_call_group

  private

  def membership_in_call_group
    unless call&.group_id == membership&.group_id
      errors.add(:membership, "must be a member in the call's group")
    end
  end
end
