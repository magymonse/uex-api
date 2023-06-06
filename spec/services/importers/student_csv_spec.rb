require "rails_helper"
require Rails.root.join("app/services/importers/student_csv")

RSpec.describe StudentCSV do
  describe "#import" do
    context "with valid params" do
      before do
        csv_file_path = Rails.root.join("spec/support/files/students.csv")
        student_csv = StudentCSV.new(csv_file_path)
        @result = student_csv.import
      end

      it "import successful" do
        expect(@result).to be true
      end

      it "populate database" do
        expect(Student.count).to eq(0)
      end
    end
  end
end
