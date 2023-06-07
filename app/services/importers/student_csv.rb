class StudentCSV
  EXPECTED_COLUMNS = %w[first_name last_name email phone_number id_card address career]
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @students_careers = {}
    @persons = []
    @successful_import_count = 0
    @rows_errors = {}
    @validation_errors = []
  end

  def import
    return unless valid?

    import_persons
    import_students
  end

  def import_result_msg
    return @validation_errors.join(". ") if @validation_errors.any?

    msg = I18n.t("services.importers.imported_records", count: @successful_import_count)
    msg << ". " + I18n.t("services.importers.no_imported_records", rows_errors: rows_errors) if @rows_errors.any?
    msg
  end

  private

  def import_persons
    persons = []
    careers = Career.pluck(:name, :id).to_h
    index = 1

    CSV.foreach(@csv_file_path, headers: true) do |row|
      break unless valid_columns?(row.headers)

      career_id, id_card = get_values(careers, row)
      person = Person.new(row.to_h.except("career"))
      if person.valid?
        persons << person
        @students_careers[id_card] = career_id
      else
        @rows_errors[index] = person.errors.full_messages.to_sentence
      end
      index += 1
    end

    import_result = Person.import(persons, validate: false)
    @persons = Person.where(id: import_result.ids).pluck(:id_card, :id).to_h
  end

  def get_values(careers, row)
    id_card = row["id_card"]
    career = row["career"]
    career_id = careers[career]
    return career_id, id_card
  end

  def import_students
    students = []
    persons_to_delete = []
    index = 1

    @students_careers.each do |id_card, career_id|
      person_id = @persons[id_card]
      student = Student.new(person_id: person_id, career_id: career_id)
      if student.valid?
        students << student
      else
        # Save related person to delete because can't exist person without related student
        persons_to_delete.push(person_id)
        @rows_errors[index] = student.errors.full_messages.to_sentence
      end
      index += 1
    end

    Person.where(id: persons_to_delete).delete_all
    import_result = Student.import(students, validate: false)
    @successful_import_count = import_result.ids.size
  end

  def rows_errors
    @rows_errors.map { |key, value| " #{I18n.t("services.importers.row")} #{key} => #{value}"}.join(", ")
  end

  def valid?
    valid_file?
  end

  def valid_file?
    if @csv_file_path.blank?
      @validation_errors << I18n.t("services.importers.blank_csv_file")
      return false
    end
    true
  end

  def valid_columns?(received_columns)
    missing_columns = EXPECTED_COLUMNS - received_columns
    if missing_columns.any?
      @validation_errors << I18n.t("services.importers.missing_columns", missing_columns: missing_columns.join(", "))
      return false
    end
    true
  end
end
