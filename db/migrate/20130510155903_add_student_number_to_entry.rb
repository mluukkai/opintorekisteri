class AddStudentNumberToEntry < ActiveRecord::Migration
  def up
    add_column :entries, :student_number, :string
  end

  def down
    remove_column :entries, :student_number
  end
end
