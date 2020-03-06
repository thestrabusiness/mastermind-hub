class Call < ApplicationRecord
  belongs_to :group
  has_many :notes
  has_many :commitments

  def self.after(date)
    where('scheduled_on::DATE > ?', date)
  end

  def self.before(date)
    where('scheduled_on::DATE < ? ', date)
  end

  def self.on(date)
    where('scheduled_on::DATE = ?', date)
  end
end
