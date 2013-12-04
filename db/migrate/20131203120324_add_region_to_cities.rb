class AddRegionToCities < ActiveRecord::Migration
  def up
		add_column :cities, :region, :string
  end
	def down
		remove_column :cities, :region
	end
end
