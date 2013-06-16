class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :term
      t.date :date

      t.timestamps
    end
  end
end
