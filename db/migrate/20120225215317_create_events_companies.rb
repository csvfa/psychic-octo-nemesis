class CreateEventsCompanies < ActiveRecord::Migration
  def change
    create_table :events_companies do |t|
      t.string :name
      t.text :address
      t.string :website
      t.string :email
      t.string :phone
      t.text :service_agreement
      t.text :payment_terms
      t.text :notes

      t.timestamps
    end
  end
end
