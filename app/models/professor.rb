class Professor < ApplicationRecord
  include Persons

  belongs_to :person, dependent: :destroy
  has_many :professor_careers, dependent: :destroy
  has_many :careers, through: :professor_careers


  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :professor_careers, allow_destroy: true

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end
  end
end
