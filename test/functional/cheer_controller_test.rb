# -*- encoding : utf-8 -*-
require 'test_helper'

class CheerControllerTest < ActionController::TestCase
  test "should post index target_id none" do
    post :index
    assert_redirected_to error_index_path
  end

  test "should post index" do
    post :index, target_id: users(:two).id
    assert_response :success
  end

end
