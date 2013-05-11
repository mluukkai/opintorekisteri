class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :code
      t.string :name
      t.decimal :credits
      t.string :grade
      t.string :status
      t.integer :statuscode
      t.string :ordering
      t.string :creditDate
      t.date :date

      t.timestamps
    end
  end
end
