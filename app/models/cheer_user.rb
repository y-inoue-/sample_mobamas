class CheerUser < ActiveRecord::Base
  attr_accessible :comment, :target_id, :user_id

  belongs_to :user
  belongs_to :target, class_name: "User"
end
