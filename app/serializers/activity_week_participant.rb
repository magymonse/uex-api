class ActivityWeekParticipantSerializer < ActiveModel::Serializer
  attributes :activity_week_id, :hours, :evaluation, :person_id, :entity_type
    
  belongs_to :person_id
  belongs_to :activity_week
end
