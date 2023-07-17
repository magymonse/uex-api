class Models::UpdateStudentHoursParticipation < ApplicationService

  def initialize(activity_week_participants)
    @activity_week_participants = activity_week_participants
  end

  def call
    super

    register_hours!
  end

  private
  def validate_params!
    raise "Missing activity_week_participants param" unless @activity_week_participants
  end

  def register_hours!
    students_to_update = []
    participants_to_update = []
 
    ActivityWeekParticipant.transaction do
      student_participants.each do |participant|
        next if participant._destroy || participant.hours == participant.registered_hours

        student = students[participant.participable_id]
        next unless student

        new_hours = student.hours
        new_hours -= participant.registered_hours if participant.registered_hours
        new_hours += participant.hours

        student.status = Student.update_hours(student, new_hours)
        students_to_update << student

        participant.registered_hours = participant.hours
        participants_to_update << participant
      end

      Student.import!(students_to_update.uniq, on_duplicate_key_update: [:hours, :status])
      ActivityWeekParticipant.import!(participants_to_update.uniq, on_duplicate_key_update: [:registered_hours])
    end

    @activity_week_participants
  end

  def students
    @_students ||= Student.where(id: student_participants.map(&:participable_id).uniq).index_by(&:id)
  end

  def student_participants
    @_student_participants ||= @activity_week_participants.select { |participant| participant.participable_type == Student.to_s }
  end
end
