require 'test_helper'

class CharacterImagesControllerTest < ActionController::TestCase
  setup do
    @character_image = character_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:character_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create character_image" do
    assert_difference('CharacterImage.count') do
      post :create, character_image: { alt_text: @character_image.alt_text, character_id: @character_image.character_id, primary: @character_image.primary, url: @character_image.url }
    end

    assert_redirected_to character_image_path(assigns(:character_image))
  end

  test "should show character_image" do
    get :show, id: @character_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @character_image
    assert_response :success
  end

  test "should update character_image" do
    patch :update, id: @character_image, character_image: { alt_text: @character_image.alt_text, character_id: @character_image.character_id, primary: @character_image.primary, url: @character_image.url }
    assert_redirected_to character_image_path(assigns(:character_image))
  end

  test "should destroy character_image" do
    assert_difference('CharacterImage.count', -1) do
      delete :destroy, id: @character_image
    end

    assert_redirected_to character_images_path
  end
end
