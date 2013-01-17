class CreateCheerComments < ActiveRecord::Migration
  def change
    create_table :cheer_comments do |t|
      t.integer :user_id, default: 0
      t.integer :target_id, default: 0
      t.string :comment, default: "hello!"
      t.boolean :disp, default: true

      t.timestamps
    end
  end
end
