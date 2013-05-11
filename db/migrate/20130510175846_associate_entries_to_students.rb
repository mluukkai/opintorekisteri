class AssociateEntriesToStudents < ActiveRecord::Migration
  def up
    Entry.all.each do |e|
      student = Student.where(:student_number => e.student_number).first
      e.student = student
      e.save
    end
  end

  def down
  end
end
