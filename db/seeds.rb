# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create login user
User.create(email: "admin@demo.com", password: "demo", username: "demo")

Career.create([{name: "Ingeniería Civil"}, {name: "Ingeniería Electromecánica"}, {name: "Ingeniería Informática"}])

ActivityType.create([{name: "CURSOS EXTRACURRICULARES"},
                    {name: "PRESTACIONES DE SERVICIOS"},
                    {name: "EVENTOS ACADÉMICOS"}])

Organization.create([{name: "Integradevs", address: "Encarnacion", current_agreement: true, contact_name: "Veronica Solano"},
                    {name: "Facultad de Ingeniería", address: "Encarnacion", current_agreement: true, contact_name: "Oscar Trochez"},
                    {name: "CENADE", address: "Encarnacion", current_agreement: true, contact_name: "Jose Perez"}])

students = [
  {first_name: "Felix", last_name: "Rojas", email: "felixjas@fiuni.net", phone_number: "0972-962163", id_card: "3140126", address: "Encarnacion", sex: 0},
  {first_name: "Alba", last_name: "Flores", email: "alba@fiuni.net", phone_number: "0996-266093", id_card: "4012208", address: "San Juan del Parana", sex: 1},
  {first_name: "Emilio", last_name: "Herrera", email: "herreraemilio@fiuni.net", phone_number: "0961-147229", id_card: "5684899", address: "Cambyreta", sex: 0}
]

students.each do |st|
  student = Student.new(career_id: Career.last.id)
  student.build_person(st)
  student.save
end


#professors = [
#{first_name: "Mirta", last_name: "Arambulo", email: "mirta@fiuni.net", phone_number: "0981-595665", id_card: "2095417", address: "Encarnacion", sex: 1},
#{first_name: "Arnaldo", last_name: "Ocampos", email: "arnaldo@fiuni.net", phone_number: "0982-944160", id_card: "1988475 ", address: "Encarnacion", sex: 0}
#]

#professors.each do |pro|
#  professor = Professor.new(career_id: Career.last.id)
#  professor.build_person(pro)
#  professor.save
#end