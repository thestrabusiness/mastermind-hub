# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :call
  belongs_to :author, class_name: "User"

  validates :body, presence: true
end
