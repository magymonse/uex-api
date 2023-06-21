class CreateActivityServices < ApplicationService
  def initialize(params)
    @params = params
  end

  def call
    super

    create_record!

    {
      record: activity
    }
  end

  def create_record!
    activity.activity_weeks << ActivityWeek.new({ start_date: activity.start_date, end_date: activity.end_date })
    activity.save!
  end

  private

  def activity
    @_activity ||= Activity.new(@params)
  end

  def validate_params!
    raise "Missing activity params" unless @params
  end
end
