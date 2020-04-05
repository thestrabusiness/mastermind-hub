# frozen_string_literal: true

class CallPage
  attr_reader :call, :group, :timer

  def initialize(call, current_user)
    @call = call
    @viewer = current_user
    @group = call.group
    @timer = call.timers.last
  end

  def viewing_todays_call?
    call == todays_call
  end

  def viewing_upcoming_call?
    call.scheduled_on > Date.current
  end

  def viewing_previous_call?
    call.scheduled_on < Date.current
  end

  def previous_weeks_call
    call.previous_call
  end

  def previous_weeks_commitments
    previous_weeks_call.commitments.includes(membership: :user)
  end

  def next_call
    group.next_call(call) || group.upcoming_call
  end

  def viewer_is_facilitator?
    group.facilitator == viewer
  end

  def viewer_added_commitment?
    call.commitments.any? { |c| c.membership.user == viewer }
  end

  def viewer_can_update_commitment?(commitment)
    viewer == commitment.user || viewer_is_facilitator?
  end

  def notes
    call.notes
  end

  def call_title_text
    "#{call_label} #{call_date_text}"
  end

  private

  attr_reader :viewer

  def call_date_text
    DateTimeFormatter.month_day_time(call.scheduled_on)
  end

  def call_label
    if viewing_todays_call?
      "Today's Call: "
    else
      "Call on:"
    end
  end

  def todays_call
    group.todays_call
  end
end
