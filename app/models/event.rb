class Event < ApplicationRecord
  belongs_to :user
  has_many :users, through: :invites
  has_many :users, through: :confirms
  has_many :users, through: :declines
  has_many :users, through: :watching

  validates :name, :date, :location, :description, :category,
            :ticketing, :age_restriction, presence: true
end
