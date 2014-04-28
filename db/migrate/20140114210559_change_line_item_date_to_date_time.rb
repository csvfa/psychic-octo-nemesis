class ChangeLineItemDateToDateTime < ActiveRecord::Migration
  def up
    change_column :line_items, :entry_date, :datetime
  end

  def down
    change_column :line_items, :entry_date, :date
  end
end
