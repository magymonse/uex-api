require Rails.root.join("lib/utility")
class Exports::StatisticalReportGeneratorServices < ApplicationService

  def initialize(params)
    @career = Career.find(params[:career_id])
    @semester_start_date = params[:semester_start_date]&.to_date
    @semester_end_date = params[:semester_end_date]&.to_date
  end

  def call
    super

    {
      data_stream: generate_xlsx_file.to_stream(),
      filename: file_name
    }
  end

  def generate_xlsx_file
    Axlsx::Package.new do |p|
      wrap = p.workbook.styles.add_style alignment: {vertical: :center, wrap_text: true}
      title_header = p.workbook.styles.add_style :b => true, alignment: {horizontal: :center, wrap_text: true}
      subtitle = p.workbook.styles.add_style :bg_color => "d9d2e9", :b => true, alignment: {horizontal: :center, wrap_text: true}, :border => { :style => :thin, :color => "000000"}
      p.workbook.add_worksheet(name: 'Table') do |sheet|
        sheet.add_row ['UNIVERSIDAD NACIONAL DE ITAPÚA'], style: title_header
        sheet.merge_cells "A1:P1"
        sheet.add_row ['Dirección Académica- Departamento de Estadística'], style: title_header
        sheet.merge_cells "A2:P2"
        sheet.add_row ['Rectorado'], style: title_header
        sheet.merge_cells "A3:P3"
        sheet.add_row ['Facultad de Ingeniería'], style: title_header
        sheet.merge_cells "A4:P4"

        sheet.add_row ['Semestre', 'FORM. D.A.E N']
        sheet.add_row ['Mes/A']
        sheet.add_row ['Extensión Universitaria'], style: subtitle
        sheet.merge_cells "A7:P7"
        sheet.add_row ['Facultad', 'Sede/Filial', 'Carrera', 'Descripción de Actividad', 'Participación Virtual', 'Cantidad de Actividades','Docentes Involucrados', '', 'Estudiantes Involucrados', '', 'Beneficiarios', '', 'Fecha', 'Programa de Extensión Institucional', 'Linea de Extensión Institucional', 'Vinculación ODS'], style: subtitle
        sheet.add_row ['', '', '', '', '', '', 'M', 'F', 'M', 'F', 'M', 'F', '', '', '', ''], style: subtitle

        sheet.merge_cells "G8:H8"
        sheet.merge_cells "I8:J8"
        sheet.merge_cells "K8:L8"

        sheet.merge_cells "A8:A9"
        sheet.merge_cells "B8:B9"
        sheet.merge_cells "C8:C9"
        sheet.merge_cells "D8:D9"
        sheet.merge_cells "E8:E9"
        sheet.merge_cells "F8:F9"
        sheet.merge_cells "M8:M9"
        sheet.merge_cells "N8:N9"
        sheet.merge_cells "O8:O9"
        sheet.merge_cells "P8:P9"

        index = 1
        activities = Activity.joins(:careers).where(careers: {id: @career.id})
        activities.each do |activity|
          start_date = I18n.l(activity.start_date, format: :default)
          end_date = I18n.l(activity.end_date, format: :default)
          virtual_participation = Utility.translate_boolean(activity.virtual_participation)
          institutional_program = Utility.translate_boolean(activity.institutional_program)
          beneficiaries = BeneficiaryDetail.where(activity_id: activity.id)
          activity_quantity = ActivityWeek.where(activity_id: activity.id).count
          sheet.add_row ['Ingeniería', 'Encarnación', @career.name, activity.name, virtual_participation, activity_quantity, "male_professors", "female_professors", "male_students", "female_students", beneficiaries.number_of_men, beneficiaries.number_of_women, start_date + " - " + end_date, institutional_program, activity.institutional_extension_line, activity.ods_vinculation] , style: wrap
        end
        sheet.add_row ['Total', '', '', '', '', '', '0', '0', '0', '0', '0', '0', '', '', '', ''], style: subtitle

        sheet.add_row
        sheet.add_row ['Facultad', '', 'Total Primer Semestre', 'Total Segundo Semestre'], style: subtitle
        sheet.add_row ['Suma Total:', '', '0', '0'], style: subtitle
      end
    end
  end

  private
  def people_by_sex(people)
    result = {
      male: 0,
      female: 0
    }

    people.each do |id, sex|
      if sex == "male"
        result[:male] += 1
      else
        result[:female] += 1
      end
    end

    result
  end
  def hello
    activities = Activity
    .includes(:careers, activity_weeks: {activity_week_participants: { participable: :person } })
    .where("activity_weeks.start_date >= :start_date and activity_weeks.end_date <= :end_date", {id: Activity.last.id, start_date: @start_date, end_date: @end_date})
  students = {}
  professors = {}
  activities.first.activity_weeks.each do |aw|
    aw.activity_week_participants.each do |awp|
      students[awp.participable_id] = awp.participable.person.sex if awp.student?
      professors[awp.participable_id] = awp.participable.person.sex if awp.professor?
    end
  end
  end

  def file_name
    "Reporte_Estadistico.xlsx"
  end

end
