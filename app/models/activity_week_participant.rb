class ActivityWeekParticipant < ApplicationRecord
  belongs_to :activity_week
  belongs_to :person
  validates_presence_of :entity_type
end