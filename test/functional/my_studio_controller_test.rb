# -*- encoding : utf-8 -*-
require 'test_helper'

class MyStudioControllerTest < ActionController::TestCase

  setup do
    set_current_user
  end

  test "should get index" do
    get :index, format: :json
    assert_response :success

    result = JSON.parse(response.body)
    assert_equal result['user_name'], 'user0001'
    assert_equal result['cheer_point'], 0
  end

end
