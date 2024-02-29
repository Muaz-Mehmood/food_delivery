class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :role, :integer, default: 0
  end
end
