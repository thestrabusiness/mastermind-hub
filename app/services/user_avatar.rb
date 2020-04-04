class UserAvatar
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper

  def initialize(user)
    @user = user
  end

  def self.render(user)
    new(user).render
  end

  def render
    if user_has_gravatar?
      image_tag(image_src, class: "avatar")
    else
      content_tag(:div, user.initials, class: "avatar")
    end
  end

  private

  attr_reader :user

  def email_hash
    Digest::MD5.hexdigest(user.email)
  end

  def image_src
    "https://www.gravatar.com/avatar/#{email_hash}"
  end

  def user_has_gravatar?
    uri = URI("#{image_src}?d=404")
    response = Net::HTTP.get_response(uri)

    response.is_a?(Net::HTTPSuccess)
  end
end
