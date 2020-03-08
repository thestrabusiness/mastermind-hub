class CallPage
  attr_reader :call, :group, :timer

  def initialize(call)
    @call = call
    @group = call.group
    @timer = call.timers.last
  end

  def viewing_todays_call?
    @call == todays_call
  end

  def last_weeks_call
    @group.previous_calls.last
  end

  def next_call
    @group.next_call(@call) || @group.upcoming_call
  end

  def viewer_is_facilitator?(viewer)
    @group.facilitator == viewer
  end

  def viewer_added_commitment?(viewer)
    next_call.commitments.any? { |c| c.membership.user == viewer }
  end

  def notes
    @call.notes
  end

  private

  def todays_call
    @group.todays_call
  end
end
