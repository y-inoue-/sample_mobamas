class CheerComment < ActiveRecord::Base
  attr_accessible :comment, :disp, :target_id, :user_id

  belongs_to :user
  belongs_to :target, class_name: "User"
end
