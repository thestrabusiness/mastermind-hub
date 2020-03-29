# frozen_string_literal: true

class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  FACILITATOR = "facilitator"
  MEMBER = "member"
  ROLES = [FACILITATOR, MEMBER].freeze

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end
end
