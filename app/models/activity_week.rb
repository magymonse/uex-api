class ActivityWeek < ApplicationRecord
  belongs_to :activity
  has_many :activity_week_participants

  validates_presence_of :start_date, :end_date
end