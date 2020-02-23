class User < ApplicationRecord
  include Clearance::User

  FACILITATOR = 'facilitator'.freeze
  MEMBER = 'member'.freeze
  ROLES = [FACILITATOR, MEMBER].freeze

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def first_plus_initial
    "#{first_name} #{last_name[0]}."
  end

  def self.select_options
    all.map { |user| [user.full_name, user.id] }
  end
end
