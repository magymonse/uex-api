module Persons
  extend ActiveSupport::Concern

  class_methods do
    def global_search(text)
      joins(:person).
        where("CONCAT_WS(' ', first_name, last_name) ILIKE :search OR email ILIKE :search OR phone_number ILIKE :search", search: "%#{text}%")
    end
  end
end