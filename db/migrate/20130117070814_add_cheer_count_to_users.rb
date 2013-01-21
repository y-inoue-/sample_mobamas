class AddCheerCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cheer_count, :integer, default: 0
    add_column :users, :cheer_updated_at, :timestamps
  end
end
