# frozen_string_literal: true

class UserAvatar
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TagHelper

  class SizeNotDefined < StandardError; end

  AVATAR_SIZES = [:small, :large].freeze
  LARGE_SIZE = 250

  AVATAR_PROPS = {
    small: OpenStruct.new(css_class: nil, gravatar_size: nil),
    large: OpenStruct.new(css_class: " avatar-large", gravatar_size: LARGE_SIZE)
  }.freeze

  def initialize(user, size)
    unless AVATAR_SIZES.include?(size)
      raise SizeNotDefined, "Size must be included in AVATAR_SIZES"
    end

    @user = user
    @avatar_props = AVATAR_PROPS[size]
  end

  def self.render(user, size: :small)
    new(user, size).render
  end

  def render
    if user_has_gravatar?
      image_tag(image_src, class: "avatar#{avatar_props.css_class}")
    else
      content_tag(:div, user.initials,
                  class: "avatar#{avatar_props.css_class}")
    end
  end

  private

  attr_reader :avatar_props, :user

  def email_hash
    Digest::MD5.hexdigest(user.email)
  end

  def image_src
    "https://www.gravatar.com/avatar/#{email_hash}#{size_param}"
  end

  def size_param
    "?s=#{avatar_props.gravatar_size}" unless avatar_props.gravatar_size.nil?
  end

  def user_has_gravatar?
    uri = URI("#{image_src}?d=404")
    response = Net::HTTP.get_response(uri)

    response.is_a?(Net::HTTPSuccess)
  end
end
