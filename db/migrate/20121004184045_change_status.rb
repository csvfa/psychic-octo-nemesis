class ChangeStatus < ActiveRecord::Migration
  def up
  	add_column :statuses, :action, :string
  	add_column :statuses, :imageable_id, :integer
  	add_column :statuses, :imageable_type, :string
  	rename_table :statuses, :events
  end

  def down
    rename_table :events, :statuses
  	remove_column :statuses, :action
  	remove_column :statuses, :imageable_id
  	remove_column :statuses, :imageable_type
  end
end
