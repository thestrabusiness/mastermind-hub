# frozen_string_literal: true

class Call < ApplicationRecord
  belongs_to :group
  has_many :commitments, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :timers, dependent: :destroy
  has_many :users, through: :group

  default_scope { order(scheduled_on: :asc) }

  def self.after(date)
    where("scheduled_on::DATE > ?", date)
  end

  def self.before(date)
    where("scheduled_on::DATE < ? ", date)
  end

  def self.on(date)
    where("scheduled_on::DATE = ?", date)
  end

  def previous_call
    group.calls.before(scheduled_on).last
  end

  def next_call
    group.calls.after(scheduled_on).first
  end

  def todays_call?
    self == group.todays_call
  end

  def past_call?
    scheduled_on < Date.current
  end
end
