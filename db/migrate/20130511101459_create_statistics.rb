class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.string :started
      t.string :attrib

      t.timestamps
    end
  end
end
