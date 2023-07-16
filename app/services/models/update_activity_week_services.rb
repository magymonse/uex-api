class Models::UpdateActivityWeekServices < ApplicationService
  def initialize(activity_week, activity_week_params)
    @activity_week = activity_week
    @activity_week_params = activity_week_params
  end

  def call
    super

    update!
  end

  def update!
    ActivityWeek.transaction do
      @activity_week.assign_attributes(@activity_week_params)
      perform_update_student_hours(@activity_week.activity_week_participants) if @activity_week.activity_week_participants.any? { |p| p.registered_hours }

      @activity_week.save!
    end

    @activity_week
  end

  private

  def perform_update_student_hours(activity_week_participants)
    Models::SumActivityHoursToStudents.call(activity_week_participants)
    Models::RestHoursAfterDeleteParticipantServices.call(activity_week_participants)
  end

  def validate_params!
    raise "Missing activity_week" unless @activity_week
    raise "Missing activity_week_params" unless @activity_week_params
  end
end
