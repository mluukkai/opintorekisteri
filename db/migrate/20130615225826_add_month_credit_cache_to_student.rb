class AddMonthCreditCacheToStudent < ActiveRecord::Migration
  def up
    add_column :students, :month_credits, :text
  end

  def down
    remove_column :students, :month_credits
  end
end
