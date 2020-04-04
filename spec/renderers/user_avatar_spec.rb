# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserAvatar do
  describe "render" do
    context "when the user has a gravatar" do
      it "renders an image with the gravatar src" do
        response = Net::HTTPSuccess.new("1.1", 200, "")
        allow(Net::HTTP).to receive(:get_response).and_return(response)

        user = create(:user)
        email_hash = Digest::MD5.hexdigest(user.email)
        image_src = "https://www.gravatar.com/avatar/#{email_hash}"

        expect(UserAvatar.render(user))
          .to eq "<img class=\"avatar\" src=\"#{image_src}\" />"
      end

      it "renders the user's initials when the user doesn't have a gravatar" do
        response = Net::HTTPNotFound.new("1.1", 404, "")
        allow(Net::HTTP).to receive(:get_response).and_return(response)
        user = create(:user)

        expect(UserAvatar.render(user)).to eq "<div class=\"avatar\">EM</div>"
      end
    end
  end
end
