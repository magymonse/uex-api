class Student < ApplicationRecord
  include Persons

  belongs_to :person, dependent: :destroy
  belongs_to :career

  accepts_nested_attributes_for :person

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end
  end
end
