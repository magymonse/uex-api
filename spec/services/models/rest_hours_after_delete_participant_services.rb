require "rails_helper"

describe Models::RestHoursAfterDeleteParticipantServices do
  let(:student_hours) { 5 }
  let!(:student) { create(:student, hours: student_hours) }
  let!(:activity) { create(:activity) }
  let!(:activity_week) { create(:activity_week, activity: activity) }
  let(:registered_hours) { student_hours - 2 }
  let(:participant_hours) { registered_hours }
  let!(:activity_week_participant) { 
    create(:activity_week_participant,
      activity_week: activity_week,
      participable: student,
      hours: participant_hours,
      registered_hours: registered_hours
    )
  }

  subject { Models::RestHoursAfterDeleteParticipantServices.call(activity_week_participant_params) }

  before do
    allow(activity_week_participant).to receive(:_destroy).and_return(true)
  end

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

        context "when participant hour has already been regitered" do
          it "should rest registered_hours to student hours" do
            subject

            expect { student.reload }.to change { student.hours }.by(-registered_hours)
          end

          context "when participant hour is different than registered_hour" do
            let(:participant_hours) { registered_hours + 10 }
            it "should always rest registered_hours hours to student hours" do
              subject

              expect { student.reload }.to change { student.hours }.by(-registered_hours)
            end
          end
        end

        context "when participant hour hasn't already been regitered" do
          let(:registered_hours) { nil }

          it "should not rest registered_hours to student hours" do

            expect { student.reload }.to_not change { student.hours }
          end

          context "when registered_hours is nil but hours is present" do
            let(:participant_hours) { 10 }

            it "should not rest hours to student hours" do
              subject

              expect { student.reload }.to_not change { student.hours }
            end
          end
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
