class AddLatitudeToCities < ActiveRecord::Migration
    def up
		add_column :cities, :latitude, :integer
    end
	def down
		remove_column :cities, :latitude
	end
end
