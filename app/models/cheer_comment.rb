class CheerComment < ActiveRecord::Base
  attr_accessible :comment, :disp, :target_id, :user_id
end
