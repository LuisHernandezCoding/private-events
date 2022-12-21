class Event < ApplicationRecord
  belongs_to :organizer

  has_many :event_interests
  has_many :interests, through: :event_interests, dependent: :destroy
  has_many :categories, through: :interests

  has_many :event_atendees
  has_many :atendees, through: :event_atendees, source: :profile, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :date, presence: true
  validates :hour, presence: true
end
