class Api::StudentsController < Api::BaseController
  before_action :set_student, only: [:create, :show, :update, :destroy]

  def create
    @student.save!
    render json: @student
  end

  def index
    students = Student.includes(:person).search(params).paginate(page: page, per_page: per_page)
    render json: students, each_serializer: StudentSerializer, meta: meta_attributes(students)
  end

  def show
    render json: @student
  end

  def update
    @student.update!(student_params)
    render json: @student
  end

  def destroy
    @student.destroy!
  end

  def import_csv
    # Leer el archivo CSV enviado por el cliente
    file = params[:file]
    spreadsheet = Roo::CSV.new(file.path)

    # Procesar los datos del archivo CSV
    spreadsheet.each_with_index do |row, index|
      next if index.zero? # Ignorar la primera fila (encabezados)

      # Crear un nuevo estudiante a partir de los datos del archivo CSV
      person = Person.new(
        first_name: row[0],
        last_name: row[1],
        email: row[2],
        phone_number: row[3],
        id_card: row[4],
        address: row[5]
      )
      student= Student.new(person: person)

      # Asignar la carrera del estudiante si se especificó en el archivo CSV
      career_name = row[6]
      career = Career.find_by(name: career_name)
      student.career = career if career

      # Guardar el estudiante en la base de datos
      unless student.save
        render json: { error: "Error al importar el estudiante en la fila #{index + 1}: #{student.errors.full_messages.join(', ')}" }, status: :unprocessable_entity and return
      end
    end

    # Devolver una respuesta exitosa al cliente
    render json: { message: 'Importación exitosa de estudiantes desde archivo CSV' }, status: :ok
  end

  private
  def set_student
    @student = if params[:id]
      Student.includes(:person).find(params[:id])
    else
      Student.new(student_params)
    end
  end

  def student_params
    params[:student][:person_attributes] = params[:student].delete(:person)
    params.require(:student).permit(:id, :hours, :submitted, :admission_year, :career_id,
      person_attributes: [:id, :name, :first_name, :last_name, :email, :phone_number, :id_card, :address])
  end
end
