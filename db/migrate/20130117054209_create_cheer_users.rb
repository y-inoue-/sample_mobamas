class CreateCheerUsers < ActiveRecord::Migration
  def change
    create_table :cheer_users do |t|
      t.integer :user_id, default: 0
      t.integer :target_id, default: 0
      t.boolean :comment, default: false

      t.timestamps
    end
  end
end
