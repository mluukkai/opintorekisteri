class AddOtherAttributeToStatistics < ActiveRecord::Migration
  def up
    add_column :statistics, :attrib2, :string
  end

  def down
    remove_column :statistics, :attrib2
  end
end
