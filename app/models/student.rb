class Student < ApplicationRecord
  belongs_to :person, dependent: :destroy
  belongs_to :career

  accepts_nested_attributes_for :person

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end

    def global_search(text)
      joins(:person).where("first_name LIKE :search OR last_name LIKE :search", search: "%#{text}%")
    end
  end
end
