# frozen_string_literal: true

class Timer < ApplicationRecord
  DURATION_RANGE = Array(1..60)
  belongs_to :user
  belongs_to :call

  validates :user, presence: true
  validates :call, presence: true

  def self.duration_select_options
    DURATION_RANGE.map { |minutes| [minutes, minutes * 60] }
  end

  def ended?
    ends_at <= Time.current
  end

  def ends_at
    created_at + duration
  end

  def initial_text
    if ended?
      "TIMES UP"
    else
      "00m 00s"
    end
  end
end
