class ActivityCareerSerializer < ActiveModel::Serializer
  attributes :activity_id, :career_id
    
  belongs_to :career
end
