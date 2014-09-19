class CreateReceivedLineItems < ActiveRecord::Migration
  def change
    create_table :received_line_items do |t|
      t.date :received_on
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :payment_method
      t.references :invoice

      t.timestamps
    end
  end
end
