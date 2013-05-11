class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :student_number
      t.string :started
      t.string :attrib

      t.timestamps
    end
  end
end
