# frozen_string_literal: true

require "rails_helper"

RSpec.describe "user creates a note", js: true do
  context "when the current user creates a note" do
    include_context "user in an active call"

    describe "creating a new note" do
      it "formats the user's first name, a colon, and then their note" do
        fill_in "note_body", with: "this is my note"
        click_on "Create Note"
        expect(page).to have_content /Elon:\s+this is my note/
      end
    end
  end
end
