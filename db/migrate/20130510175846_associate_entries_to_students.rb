class AssociateEntriesToStudents < ActiveRecord::Migration
  def up
    Entry.all.each do |e|
      student = Student.where(:student_number => e.student_number).first
      if e.student.nil?
        e.student = student
        e.save
      end
    end
  end

  def down
  end
end
