class Call < ApplicationRecord
  belongs_to :group
  has_many :commitments
  has_many :notes
  has_many :timers

  default_scope { order(scheduled_on: :asc) }

  def self.after(date)
    where('scheduled_on::DATE > ?', date)
  end

  def self.before(date)
    where('scheduled_on::DATE < ? ', date)
  end

  def self.on(date)
    where('scheduled_on::DATE = ?', date)
  end

  def previous_call
    Call.before(scheduled_on).last
  end
end
