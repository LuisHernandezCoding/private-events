class Event < ApplicationRecord
  belongs_to :profile
  belongs_to :category

  validates :name, :date, :location, :description, :category,
            :ticketing, :age_restriction, presence: true
end
