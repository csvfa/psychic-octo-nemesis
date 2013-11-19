class CreateCityCoachJoinTable < ActiveRecord::Migration
  def change
    create_table :cities_coaches, :id => false do |t|
      t.integer :city_id
      t.integer :coach_id
      
    remove_column :coaches, :city_id
    end
  end
end
