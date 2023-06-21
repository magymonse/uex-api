require Rails.root.join("lib/utility")
class Imports::StudentCsv
  EXPECTED_COLUMNS = %w[first_name last_name email phone_number id_card address career]
  TRANSLATED_SEX = I18n.t("activerecord.attributes.person.sexes").invert.transform_keys(&:downcase)

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @students_careers = {}
    @persons = []
    @successful_import_count = 0
    @rows_errors = {}
    @errors = []
  end

  def import
    return unless valid?

    ActiveRecord::Base.transaction do
      _import
    end
  rescue StandardError
    @errors << I18n.t("services.imports.messages.unexpected_error")
  end

  def import_result_msg
    return validation_errors_msg if @errors.any?
    result_msg
  end

  private

  def _import
    persons = []
    index = 0

    CSV.foreach(@csv_file_path, headers: true) do |row|
      break unless valid_columns?(row.headers)
      index += 1

      person = Person.new(person_attributes(row))
      person.build_student(career_id: career_id(row))

      unless person.student.valid?
        @rows_errors[index] = person.student.errors.full_messages.to_sentence
        next
      end

      if person.valid?
        persons << person
      else
        @rows_errors[index] = person.errors.full_messages.to_sentence
      end
    end

    import_result = Person.import(persons, validate: false, recursive: true)
    @successful_import_count = import_result.ids.size
  end

  def careers
    @_careers ||=
      begin
        careers = Career.pluck(:name, :id).to_h
        careers.transform_keys { |key| Utility.clean_string(key) }
      end
  end

  def career_id(row)
    career = Utility.clean_string(row["career"])
    careers[career]
  end

  def person_attributes(row)
    attrs = row.to_h.except("career", "sex")
    attrs["sex"] = TRANSLATED_SEX[Utility.clean_string(row["sex"])]
    attrs
  end

  def rows_errors
    @rows_errors.map { |key, value| " #{I18n.t("services.imports.row")} #{key} => #{value}"}.join(", ")
  end

  def validation_errors_msg
    msg = I18n.t("services.imports.messages.import_fail")
    msg << ". " +  @errors.join(". ")
    msg
  end

  def result_msg
    msg = I18n.t("services.imports.messages.imported_records", count: @successful_import_count)
    msg << ". " + I18n.t("services.imports.messages.no_imported_records", rows_errors: rows_errors) if @rows_errors.any?
    msg
  end

  def valid?
    valid_file?
  end

  def valid_file?
    if @csv_file_path.blank?
      @errors << I18n.t("services.imports.messages.blank_csv_file")
      return false
    end
    true
  end

  def valid_columns?(received_columns)
    missing_columns = EXPECTED_COLUMNS - received_columns
    if missing_columns.any?
      @errors << I18n.t("services.imports.messages.missing_columns", missing_columns: missing_columns.join(", "))
      return false
    end
    true
  end
end
