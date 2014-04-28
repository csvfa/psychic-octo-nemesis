class AddPricePerGuestToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :price_per_guest, :decimal, :precision => 8, :scale => 2
  end
end
