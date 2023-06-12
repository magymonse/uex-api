class Api::ProfessorsController < Api::BaseController
  before_action :set_professor, only: [:create, :show, :update, :destroy]

  def create
    @professor.save!
    render json: @professor
  end

  def index
    professors = Professor.includes(:person, professor_careers: :career).search(params).paginate(page: page, per_page: per_page)
    render json: professors, each_serializer: ProfessorSerializer, meta: meta_attributes(professors)
  end

  def show
    render json: @professor
  end

  def update
    @professor.update!(professor_params)
    render json: @professor
  end

  def destroy
    @professor.destroy!
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
      professor= Professor.new(person: person)

      careers_row = row[6]
      careers_row.gsub!('"','')
      career_names= careers_row.split(',')
      careers = Career.where(name: career_names)
      professor.careers = careers

      # Guardar el estudiante en la base de datos
      unless professor.save
        render json: { error: "Error al importar el estudiante en la fila #{index + 1}: #{professor.errors.full_messages.join(', ')}" }, status: :unprocessable_entity and return
      end
    end

    # Devolver una respuesta exitosa al cliente
    render json: { message: 'Importación exitosa de estudiantes desde archivo CSV' }, status: :ok
  end
  private
  def set_professor
    @professor = if params[:id]
      Professor.includes(:person, professor_careers: :career).find(params[:id])
    else
      Professor.new(professor_params)
    end
  end

  def professor_params
    params[:professor][:person_attributes] = params[:professor].delete(:person)
    params[:professor][:professor_careers_attributes] = params[:professor].delete(:professor_careers)
    params.require(:professor).permit(
      person_attributes: [:id, :name, :first_name, :last_name, :email, :phone_number, :id_card, :address, :sex],
      professor_careers_attributes: [:id, :career_id, :_destroy]
    )
  end
end
