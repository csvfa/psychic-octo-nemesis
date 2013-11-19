class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :code
      t.text :notes
      t.references :booking

      t.timestamps
    end
    add_index :statuses, :booking_id
  end
end
