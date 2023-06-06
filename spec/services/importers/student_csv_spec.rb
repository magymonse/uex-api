require "rails_helper"
require Rails.root.join("app/services/importers/student_csv")

RSpec.describe StudentCSV do
  describe "#import" do
    context "with valid csv content" do
      before do
        FactoryBot.create(:career, name: "Ingenieria Electromecanica")
        FactoryBot.create(:career, name: "Ingenieria Civil")

        csv_file_path = Rails.root.join("spec/support/files/valid_students.csv")
        @student_csv = StudentCSV.new(csv_file_path)
        @student_csv.import
      end

      it "populate database" do
        expect(Student.count).to eq(2)
      end

      it "import without errors" do
        expect(@student_csv.result_msg).to eq("Se importaron 2 registros")
      end
    end

    context "with invalid csv content" do
      before do
        FactoryBot.create(:career, name: "Ingenieria Civil")

        csv_file_path = Rails.root.join("spec/support/files/invalid_students.csv")
        @student_csv = StudentCSV.new(csv_file_path)
        @student_csv.import
      end

      it "populate database" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@student_csv.result_msg).to eq("Se importaron 0 registros. Filas no importadas: {2=>\"Email can't be blank and Email is invalid\", 1=>\"Career must exist\"}")
      end
    end
  end
end
