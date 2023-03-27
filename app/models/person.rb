class Person < ApplicationRecord
  validates_presence_of :email, :id_card, :first_name, :last_name
  validates_uniqueness_of :id_card, :email
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}
end
