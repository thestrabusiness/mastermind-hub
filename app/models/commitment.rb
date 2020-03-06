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
end
