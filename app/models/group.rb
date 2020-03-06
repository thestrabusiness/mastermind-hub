require 'chronic'

class Group < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :memberships
  has_many :users, through: :memberships
  has_many :timers
  has_many :calls

  enum call_day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  with_options presence: true do
    validates :name
    validates :call_day
  end

  def next_call(call)
    calls.after(call.scheduled_on).first
  end

  def upcoming_call
    existing_call = calls.after(Date.today).first

    if existing_call.nil?
      return calls.create(scheduled_on: next_call_day)
    end

    existing_call
  end

  def todays_call
    calls.on(Date.today).take
  end

  def previous_calls
    calls.before(Date.today)
  end

  def facilitator
    memberships.find_by(role: Membership::FACILITATOR)&.user
  end

  def user_select_options
    users.map { |user| [user.full_name, user.id] }
  end

  private

  def next_call_day
    Chronic.parse("next week #{call_day}")
  end
end
