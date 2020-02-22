class User < ApplicationRecord
  include Clearance::User

  FACILITATOR = 'facilitator'.freeze
  MEMBER = 'member'.freeze
  ROLES = [FACILITATOR, MEMBER].freeze

  def full_name
    "#{first_name} #{last_name}"
  end
end
