class Event < ApplicationRecord
  belongs_to :organizer

  validates :name, presence: true
  validates :description, presence: true
  validates :date, presence: true
  validates :hour, presence: true
  validates :country, presence: true
  validates :state, presence: true
  validates :city, presence: true
end
