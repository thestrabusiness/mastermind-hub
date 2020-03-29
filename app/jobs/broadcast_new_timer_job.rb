# frozen_string_literal: true

class BroadcastNewTimerJob < ApplicationJob
  def perform(page)
    ActionCable
      .server
      .broadcast "call_timer_#{page.call.id}",
                 { html: render_timer_details(page) }
  end

  def render_timer_details(page)
    ApplicationController
      .render(partial: "calls/timer_details", locals: { page: page })
  end
end
