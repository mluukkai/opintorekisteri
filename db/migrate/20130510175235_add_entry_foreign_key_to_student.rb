class AddEntryForeignKeyToStudent < ActiveRecord::Migration
  def up
    add_column :entries, :student_id, :integer
  end

  def down
    remove_column :entries, :student_id
  end
end
