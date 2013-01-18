class RemoveDispFromCheerComments < ActiveRecord::Migration
  def up
    remove_column :cheer_comments, :disp
  end

  def down
    add_column :cheer_comments, :disp, :boolean
  end
end
