class Category < ApplicationRecord
  has_many :events
  has_many :interests

  validates :name, presence: true
end
