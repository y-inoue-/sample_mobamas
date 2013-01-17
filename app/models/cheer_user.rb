class CheerUser < ActiveRecord::Base
  attr_accessible :comment, :target_id, :user_id
end
