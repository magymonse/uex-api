require "rails_helper"

describe Models::SumActivityHoursToStudents do
  let(:student_hours) { 5 }
  let!(:student) { create(:student, hours: student_hours) }
  let!(:activity) { create(:activity) }
  let!(:activity_week) { create(:activity_week, activity: activity) }
  let(:participant_hours) { 10 }
  let(:registered_hours) { nil }
  let!(:activity_week_participant) { 
    create(:activity_week_participant,
      activity_week: activity_week,
      participable: student,
      hours: participant_hours,
      registered_hours: registered_hours
    )
  }

  subject { Models::SumActivityHoursToStudents.call(activity_week_participant_params) }

  describe "#call" do
    context "with missing arguments" do
      let(:activity_week_participant_params) { nil }

      it "should raise error" do
        expect {subject}.to raise_error(RuntimeError, "Missing activity_week_participants param")
      end
    end

    context "with valid arguments" do
      context "with persisted activity_week_participants as param" do
        let(:activity_week_participant_params) { [activity_week_participant] }

        context "when participant hour hasn't already been regitered" do
          let(:participant_hours) { 10 }
          let(:registered_hours) { nil }
  
          it "should sum hours to student hours" do
            subject
  
            expect { student.reload }.to change { student.hours }.by(participant_hours)
          end
  
          it "should update registered hours" do
            subject
  
            expect(activity_week_participant.reload.registered_hours).to eq(participant_hours)
          end
        end

        context "when participant hour has already been regitered" do
          context "when participant hour is equal to registered_hour" do
            let(:registered_hours) { participant_hours }
            let(:student_hours) { registered_hours }

            it "student hour should not change" do
              subject

              expect { student.reload }.to_not change { student.hours }
            end
          end

          context "when participant hour is less than registered_hour" do
            let(:registered_hours) { participant_hours + 1 }
            let(:student_hours) { registered_hours }

            it "should rest registered_hours and then sum participant_hours" do
              subject

              expect(student.reload.hours).to eq(participant_hours)
            end

            it "should update registered hours" do
              subject
    
              expect(activity_week_participant.reload.registered_hours).to eq(participant_hours)
            end
          end

          context "when participant hour is bigger than registered_hour" do
            let(:registered_hours) { participant_hours - 1 }
            let(:student_hours) { registered_hours }

            it "should rest registered_hours and then sum participant_hours" do
              subject

              expect(student.reload.hours).to eq(participant_hours)
            end

            it "should update registered hours" do
              subject
    
              expect(activity_week_participant.reload.registered_hours).to eq(participant_hours)
            end
          end
        end
      end

      context "with new activity_week_participants as param" do
        let(:new_activity_week_participant) { 
          build(:activity_week_participant,
            activity_week: activity_week,
            participable: student,
            hours: participant_hours,
            registered_hours: registered_hours
          )
        }
        let(:activity_week_participant_params) { [new_activity_week_participant] }

        it "should sum hours to student hours" do
          subject

          expect { student.reload }.to change { student.hours }.by(participant_hours)
        end
      end

      context "with empty activity_week_participants value" do
        let(:activity_week_participant_params) { [] }

        it "should not fail" do
          expect { subject }.to_not raise_error
        end
      end
    end
  end
end
