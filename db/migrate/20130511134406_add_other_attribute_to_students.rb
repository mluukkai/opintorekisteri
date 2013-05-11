class AddOtherAttributeToStudents < ActiveRecord::Migration
  def up
    add_column :students, :attrib2, :string
  end

  def down
    remove_column :students, :attrib2
  end
end
