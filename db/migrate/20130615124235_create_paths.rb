class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :started

      t.timestamps
    end
  end
end
