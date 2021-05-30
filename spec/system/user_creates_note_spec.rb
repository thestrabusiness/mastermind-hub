# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User creates a note', js: true do
  context 'when the user successfully creates note' do
    it "display the user's name and then their note" do
      user = create(:user, :with_group)
      call = create(:call, group: user.groups.first)
      note_body = 'this is my note'

      visit call_path(call, as: user)
      fill_in 'note_body', with: note_body
      click_on 'Create Note'

      expect(page).to have_content(user.first_name)
      expect(page).to have_content(note_body)
    end
  end
end
