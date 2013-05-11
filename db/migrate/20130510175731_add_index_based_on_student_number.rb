class AddIndexBasedOnStudentNumber < ActiveRecord::Migration
  def up
    add_index :students, :student_number
  end

  def down
    remove_index :students, :student_number
  end
end
