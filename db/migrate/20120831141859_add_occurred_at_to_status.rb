class AddOccurredAtToStatus < ActiveRecord::Migration
  def change
    add_column :statuses, :occurred_at, :datetime

  end
end
