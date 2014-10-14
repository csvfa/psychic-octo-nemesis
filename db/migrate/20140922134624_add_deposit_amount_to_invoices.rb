class AddDepositAmountToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :deposit_amount, :decimal, :precision => 8, :scale => 2

  end
end
