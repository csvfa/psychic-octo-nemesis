class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date :party_date
      t.references :theme
      t.text :special_requirements
      t.integer :status
      t.datetime :last_status_date
      t.text :notes
      t.references :coach
      t.datetime :when_coach_booked
      t.datetime :when_job_sheet_sent
      t.references :venue
      t.string :venue_booked_with
      t.boolean :advance_venue_payment_required

      t.timestamps
    end
    add_index :bookings, :theme_id
    add_index :bookings, :coach_id
    add_index :bookings, :venue_id
  end
end
