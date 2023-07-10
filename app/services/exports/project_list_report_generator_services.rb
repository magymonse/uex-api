class Exports::ProjectListGeneratorServices < ApplicationService
  ALLOWED_ENTITY_TYPES = [Professor, Student]

  def call
    super

    {
      data_stream: generate_xlsx_file.to_stream(),
      filename: file_name
    }
  end

  def generate_xlsx_file
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Table') do |sheet|
        sheet.add_row ['Proyecto', 'Resolución', 'Fecha de Aprobación', 'Fecha de culminación según cronograma', 'Estudiantes', 'Objetivos', 'Coordinador', 'Estado', 'Informe']

        index = 1
        activities.each do |activity|
            sheet.add_row [activity.name, activity.resolution_number, activity.approved_at, activity.end_date, "", activity.objective, activity.professor.full_name, activity.status, ""]
        end
      end
    end
  end

  private

  def validate_params!
    raise "Missing entity" unless @entity
    raise "Invalid entity type #{@entity.class}" unless ALLOWED_ENTITY_TYPES.include?(@entity.class)
  end

  def file_name
    "Listado_de_Proyectos_#{@entity.person.first_name}.xlsx"
  end
end