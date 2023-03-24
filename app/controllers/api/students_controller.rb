class Api::StudentsController < ApplicationController
  before_action :set_student, only: [:create, :show, :update, :destroy]

  def create
    @student.save!
    render json: @student
  end

  def index
    students = Student.includes(:person).search(params).paginate(page: page, per_page: per_page)
    render json: students, each_serializer: StudentSerializer, meta: meta_attributes(students)
  end

  def meta_attributes(students)
    { 
      per_page: per_page,
      total_pages: students.total_pages,
      total_objects: students.total_entries
    }
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
      person_attributes: [:name, :first_name, :last_name, :email, :phone_number, :id_card, :address])                                              
  end
end
