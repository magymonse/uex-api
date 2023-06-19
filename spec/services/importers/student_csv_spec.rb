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

      it "populate person" do
        expect(Person.count).to eq(2)
      end

      it "populate student" do
        expect(Student.count).to eq(2)
      end

      it "import without errors" do
        expect(@student_csv.import_result_msg).to eq("Se importaron 2 registros")
      end
    end

    context "with invalid csv content" do
      before do
        FactoryBot.create(:career, name: "Ingenieria Civil")

        csv_file_path = Rails.root.join("spec/support/files/invalid_students.csv")
        @student_csv = StudentCSV.new(csv_file_path)
        @student_csv.import
      end

      it "not populate person" do
        expect(Person.count).to eq(0)
      end

      it "not populate student" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@student_csv.import_result_msg).to eq("Se importaron 0 registros. Filas no importadas:  Fila 2 => Correo no puede estar en blanco y Correo no es válido,  Fila 1 => Carrera debe existir y Carrera no puede estar en blanco")
      end
    end

    context "without file" do
      before do
        @student_csv = StudentCSV.new(nil)
        @student_csv.import
      end

      it "not populate person" do
        expect(Person.count).to eq(0)
      end

      it "not populate student" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@student_csv.import_result_msg).to eq("No se pudo importar ningún registro. No se recibió ningún archivo")
      end
    end

    context "with invalid csv columns" do
      before do
        csv_file_path = Rails.root.join("spec/support/files/invalid_students_columns.csv")
        @student_csv = StudentCSV.new(csv_file_path)
        @student_csv.import
      end

      it "not populate person" do
        expect(Person.count).to eq(0)
      end

      it "not populate student" do
        expect(Student.count).to eq(0)
      end

      it "import without errors" do
        expect(@student_csv.import_result_msg).to eq("No se pudo importar ningún registro. No se encontraron las columnas: last_name en el archivo indicado")
      end
    end
  end
end
