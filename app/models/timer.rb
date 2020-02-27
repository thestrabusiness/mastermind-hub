class Timer < ApplicationRecord
  DURATION_RANGE = Array(1..60)
  belongs_to :user
  belongs_to :group

  validates :user, presence: true
  validates :group, presence: true

  def self.duration_select_options
    DURATION_RANGE.map { |minutes| [minutes, minutes * 60] }
  end

  def ends_at
    created_at + duration
  end

  def ends_at_for_js
    ends_at.strftime('%B %d, %Y %H:%M:%S UTC')
  end
end
