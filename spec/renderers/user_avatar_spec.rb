# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserAvatar do
  describe ".new" do
    it "raises if the given size is not defined in AVATAR_SIZES" do
      user = build(:user)

      expect { UserAvatar.new(user, size: "bananas") }
        .to raise_error UserAvatar::SizeNotDefined
    end
  end

  describe ".render" do
    context "when the user has a gravatar" do
      it "renders an image with the gravatar src" do
        stub_http_request success_response
        user = build(:user)
        image_url = build_gravatar_url(user)

        result = UserAvatar.render(user)

        expect(result).to eq "<img class=\"avatar\" src=\"#{image_url}\" />"
      end
    end

    it "renders the user's initials when the user doesn't have a gravatar" do
      stub_http_request error_response
      user = build(:user)

      result = UserAvatar.render(user)

      expect(result).to eq "<div class=\"avatar\">EM</div>"
    end

    context "when the size is small" do
      it "uses 'avatar' class" do
        response = Net::HTTPSuccess.new("1.1", 200, "")
        stub_http_request(response)
        user = build(:user)

        result = UserAvatar.render(user, size: :small)

        expect(result).to include "class=\"avatar\""
      end

      it "doesn't add a size query param to the image source" do
        stub_http_request success_response
        user = build(:user)

        result = UserAvatar.render(user, size: :small)

        expect(result).to_not include "?s="
      end
    end

    context "when the size is large" do
      it "uses 'avatar-large' class" do
        stub_http_request success_response
        user = build(:user)

        user_avatar = UserAvatar.render(user, size: :large)

        expect(user_avatar).to include "class=\"avatar avatar-large\""
      end

      it "adds a size query param image source" do
        stub_http_request success_response
        user = build(:user)
        image_url = build_gravatar_url(user)
        gravatar_size = UserAvatar::LARGE_SIZE

        result = UserAvatar.render(user, size: :large)

        expect(result).to include "src=\"#{image_url}?s=#{gravatar_size}\""
      end
    end
  end

  def stub_http_request(response)
    allow(Net::HTTP).to receive(:get_response).and_return(response)
  end

  def build_gravatar_url(user)
    email_hash = Digest::MD5.hexdigest(user.email)
    "https://www.gravatar.com/avatar/#{email_hash}"
  end

  def success_response
    Net::HTTPSuccess.new("1.1", 200, "")
  end

  def error_response
    Net::HTTPNotFound.new("1.1", 404, "")
  end
end
