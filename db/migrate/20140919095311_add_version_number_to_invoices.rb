class AddVersionNumberToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :version_number, :integer
  end
end
