class StudentSerializer < ActiveModel::Serializer
  attributes :id, :hours, :submitted, :admission_year, :career_id
  
  belongs_to :person
  belongs_to :career
end
