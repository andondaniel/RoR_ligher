require 'test_helper'

class SceneAppearancesControllerTest < ActionController::TestCase
  setup do
    @scene_appearance = scene_appearances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scene_appearances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scene_appearance" do
    assert_difference('SceneAppearance.count') do
      post :create, scene_appearance: { end_time: @scene_appearance.end_time, product_id: @scene_appearance.product_id, scene_id: @scene_appearance.scene_id, start_time: @scene_appearance.start_time }
    end

    assert_redirected_to scene_appearance_path(assigns(:scene_appearance))
  end

  test "should show scene_appearance" do
    get :show, id: @scene_appearance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scene_appearance
    assert_response :success
  end

  test "should update scene_appearance" do
    patch :update, id: @scene_appearance, scene_appearance: { end_time: @scene_appearance.end_time, product_id: @scene_appearance.product_id, scene_id: @scene_appearance.scene_id, start_time: @scene_appearance.start_time }
    assert_redirected_to scene_appearance_path(assigns(:scene_appearance))
  end

  test "should destroy scene_appearance" do
    assert_difference('SceneAppearance.count', -1) do
      delete :destroy, id: @scene_appearance
    end

    assert_redirected_to scene_appearances_path
  end
end
