class AddCourseSecondDate < ActiveRecord::Migration
  def up
    add_column :courses, :date2, :date
  end

  def down
    remove_column :courses, :date2
  end
end
