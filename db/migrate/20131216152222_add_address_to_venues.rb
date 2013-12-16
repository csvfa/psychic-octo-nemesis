class AddAddressToVenues < ActiveRecord::Migration
 	def up
		add_column :venues, :address, :text
 	end
	def down
		remove_column :venues, :region
	end
end
