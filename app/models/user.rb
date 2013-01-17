# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  attr_accessible :cheer_point, :name, :cheer_count
end
