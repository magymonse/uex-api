class Person < ApplicationRecord
  enum sex: {
    male: 0,
    female: 1
  }

  has_one :student

  validates_presence_of :email, :id_card, :first_name, :last_name, :sex
  validates_uniqueness_of :id_card, :email
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}
end
