class ActivityWeekParticipantSerializer < ActiveModel::Serializer
  attributes :activity_id, :number_of_men, :number_of_women, :total
end
