module ApplicationHelper
  def student_number student
    return student.student_number if session[:gndi]
    "Na"
  end

end
