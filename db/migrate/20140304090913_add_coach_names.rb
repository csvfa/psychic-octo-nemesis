class AddCoachNames < ActiveRecord::Migration
  def change
    rename_column :coaches, :name, :first_name
    add_column :coaches, :surname, :string
  end
end
