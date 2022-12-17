class Organizer < ApplicationRecord
  belongs_to :profile
  has_many :events, dependent: :destroy
end
