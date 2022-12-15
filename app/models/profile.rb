class Profile < ApplicationRecord
  belongs_to :user
  has_many :profile_interests
  has_many :interests, through: :profile_interests, dependent: :destroy
  has_many :categories, through: :interests
  has_many :events

  validates :username, :first_name, :last_name, presence: true
  validates :username, length: { in: 3..20 }
  validates :username, format: { with: /\A[a-zA-Z0-9]+\z/, message: 'only allows letters and numbers' }
  validates :username, uniqueness: true

  validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :first_name, :last_name, allow_blank: true, format:
  { with: /\A[a-zA-Z]+\z/, message: 'must be a valid name (letters only)' }

  validates :gender, allow_blank: true, inclusion: { in: %w[male female other not_say] }

  validates :title, allow_blank: true, inclusion: { in: ProfilesController.titles }

  validates :birthday, allow_blank: true, format: { with: /\A[1-2][0-9]{3}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])\z/,
                                                    message: 'must be a valid date (yyyy-mm-dd)' }

  validates :country, allow_blank: true, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :city, allow_blank: true, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :state, allow_blank: true, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :street, allow_blank: true, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
  validates :house_number, allow_blank: true, format: { with: /\A[0-9]+\z/, message: 'only allows numbers' }

  validates :phone, allow_blank: true, length: { is: 10 }
  validates :phone, allow_blank: true, numericality: { only_integer: true }
  validates :phone, allow_blank: true, format: { with: /\A[0-9]+\z/, message: 'only allows numbers' }
  validates :phone, allow_blank: true, format:
  { with: /\A[2-9]\d{2}[1-9]\d{2}\d{4}\z/, message: 'must be a valid phone number, like 555-555-5555' }

  validates :terms, acceptance: true
end
