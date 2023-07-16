require "rails_helper"

describe Models::UpdateActivityWeekServices do
  describe "#call" do
    let(:activity_week) { create(:activity_week) }
    let(:student) { create(:student, hours: 10) }
    let!(:activity_week_participant) { 
      create(:activity_week_participant,
        activity_week: activity_week,
        participable: student,
        hours: student.hours,
        registered_hours: student.hours
      )
    }
    let(:activity_week_params) {
      {
        start_date: activity_week.start_date + 1.day,
        end_date: activity_week.end_date + 1.day
      }
    }

    subject { Models::UpdateActivityWeekServices.call(activity_week, activity_week_params) }

    context "with invalid arguments" do
      context "with missing activity week" do
        subject { Models::UpdateActivityWeekServices.call(nil, activity_week_params) }

        it "should raise error" do
          expect { subject }.to raise_error(RuntimeError, "Missing activity_week")
        end
      end

      context "with missing activity week params" do
        subject { Models::UpdateActivityWeekServices.call(activity_week, nil) }

        it "should raise error" do
          expect { subject }.to raise_error(RuntimeError, "Missing activity_week_params")
        end
      end
    end

    context "with valid arguments" do
      it "should update attributes" do
        subject
        activity_week.reload

        expect(activity_week.start_date).to eq(activity_week_params[:start_date])
        expect(activity_week.end_date).to eq(activity_week_params[:end_date])
      end

      it "should create activity week participants" do
        subject
        activity_week.reload

        expect(activity_week.start_date).to eq(activity_week_params[:start_date])
        expect(activity_week.end_date).to eq(activity_week_params[:end_date])
      end

      context "with activity_week_participants attributes" do
        let(:activity_week_participant_attributes) {
          [
            {
              id: activity_week_participant.id,
              hours: activity_week_participant.hours + 1
            }
          ]
        }

        before do
          activity_week_params[:activity_week_participants_attributes] = activity_week_participant_attributes
        end

        context "with updated participant attributes" do
          it "should call SumActivityHoursToStudents" do
            activity_week.assign_attributes(activity_week_participants_attributes: activity_week_participant_attributes)
            activity_week_participants = activity_week.activity_week_participants
    
            expect(Models::SumActivityHoursToStudents).to receive(:call).with(activity_week_participants).and_call_original
    
            subject
            expect(student.reload.hours).to eq(activity_week_participant_attributes.first[:hours])
          end
    
          context "when SumActivityHoursToStudents fails" do
            before do
              allow_any_instance_of(Models::SumActivityHoursToStudents).to receive(:call).and_raise(RuntimeError)
            end
    
            it "should not save activity week" do
              expect(activity_week.updated_at).to eq(activity_week.reload.updated_at)
              expect(student.hours).to eq(student.reload.hours)
    
              expect { subject }.to raise_error(RuntimeError)
            end
          end
        end

        context "with deleted participant attributes" do
          before do
            activity_week_participant_attributes.first[:_destroy] = true
          end

          it "should call RestHoursAfterDeleteParticipantServices" do
            activity_week.assign_attributes(activity_week_participants_attributes: activity_week_participant_attributes)
            activity_week_participants = activity_week.activity_week_participants
    
            expect(Models::RestHoursAfterDeleteParticipantServices).to receive(:call).with(activity_week_participants).and_call_original
    
            subject
            expect { student.reload }.to change { student.hours }.by(-activity_week_participant.registered_hours)
          end
  
          context "when RestHoursAfterDeleteParticipantServices fails" do
            before do
              allow_any_instance_of(Models::RestHoursAfterDeleteParticipantServices).to receive(:call).and_raise(RuntimeError)
            end
  
            it "should not save activity week" do
              expect(activity_week.updated_at).to eq(activity_week.reload.updated_at)
              expect(student.hours).to eq(student.reload.hours)
  
              expect { subject }.to raise_error(RuntimeError)
            end
          end
        end
        
        context "when registered_hours is nil" do
          before do
            activity_week_participant.update!(registered_hours: nil)
          end

          it "should call to interactor" do
            activity_week.assign_attributes(activity_week_participants_attributes: activity_week_participant_attributes)
            activity_week_participants = activity_week.activity_week_participants
    
            expect(Models::SumActivityHoursToStudents).to_not receive(:call)
            expect(Models::RestHoursAfterDeleteParticipantServices).to_not receive(:call)
    
            subject
          end
        end
      end
    end
  end
end
