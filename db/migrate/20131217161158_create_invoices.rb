class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :ref
      t.date :invoice_date
      t.date :deposit_due_date
      t.date :balance_due_date

      t.timestamps
    end
  end
end
