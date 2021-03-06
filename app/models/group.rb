# frozen_string_literal: true

require "chronic"

class Group < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :calls, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :group_invites, dependent: :destroy
  has_many :users, through: :memberships

  enum call_day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday,
                  :saturday]

  with_options presence: true do
    validates :call_day
    validates :call_time
    validates :name, uniqueness: true
  end

  def self.call_day_options
    call_days.map { |k, _| [k.capitalize, k] }
  end

  def next_call(call)
    calls.after(call.scheduled_on).first
  end

  def upcoming_call
    calls.after(Date.current).first
  end

  def todays_call
    calls.on(Date.current).take
  end

  def previous_calls
    calls.before(Date.current)
  end

  def facilitator
    memberships.find_by(role: Membership::FACILITATOR)&.user
  end

  def user_select_options
    users.map { |user| [user.full_name, user.id] }
  end

  def next_call_date
    if call_day_before_type_cast == Date.current.wday
      Chronic.parse("next #{call_day} at #{DateTimeFormatter.time(call_time)}")
    else
      Chronic.parse("this #{call_day} at #{DateTimeFormatter.time(call_time)}")
    end
  end
end
