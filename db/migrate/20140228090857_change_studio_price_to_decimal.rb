class ChangeStudioPriceToDecimal < ActiveRecord::Migration
  def up
    change_column :studios, :price, :decimal, :precision => 8, :scale => 2
  end

  def down
    change_column :studios, :price, :integer
  end
end
