class AddDepartmentToCourses < ActiveRecord::Migration
  def up
    add_column :entries, :department, :string
  end

  def down
    remove_column :entries, :department
  end
end
