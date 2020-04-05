# frozen_string_literal: true

module CallCommitmentHelper
  def enable_commitment_link(commitment)
    @page.viewer_can_update_commitment?(commitment) &&
      @page.previous_weeks_commitments.include?(commitment)
  end

  def commitment_confirmation_link(commitment)
    if enable_commitment_link(commitment)
      link_to confirm_path(commitment),
              remote: true,
              method: :patch do
                icon_container(commitment)
              end
    else
      icon_container(commitment)
    end
  end

  def commitment_icon(commitment)
    commitment.completed ? "check" : "x"
  end

  def icon_class(commitment)
    commitment.completed ? "green" : "red"
  end

  def edit_commitment_alert(commitment)
    return unless commitment.call.past_call?

    "This is a past commitment. Are you sure you want to edit it?"
  end

  private

  def confirm_path(commitment)
    call_commitment_confirmation_path(commitment.call, commitment)
  end

  def commitment_param(commitment)
    params = { commitment: { completed: true } }

    params[:commitment][:completed] = false if commitment.completed?

    params
  end

  def icon_container(commitment)
    content_tag(:div,
                render("commitment_icon", commitment: commitment),
                id: dom_id(commitment, "status"),
                data: { target: "call-commitments.icon", id: commitment.id })
  end
end
