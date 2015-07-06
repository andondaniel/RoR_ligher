require 'test_helper'

class ProductPicturesControllerTest < ActionController::TestCase
  setup do
    @product_picture = product_pictures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_pictures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_picture" do
    assert_difference('ProductPicture.count') do
      post :create, product_picture: { alt_text: @product_picture.alt_text, product_id: @product_picture.product_id, url: @product_picture.url }
    end

    assert_redirected_to product_picture_path(assigns(:product_picture))
  end

  test "should show product_picture" do
    get :show, id: @product_picture
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_picture
    assert_response :success
  end

  test "should update product_picture" do
    patch :update, id: @product_picture, product_picture: { alt_text: @product_picture.alt_text, product_id: @product_picture.product_id, url: @product_picture.url }
    assert_redirected_to product_picture_path(assigns(:product_picture))
  end

  test "should destroy product_picture" do
    assert_difference('ProductPicture.count', -1) do
      delete :destroy, id: @product_picture
    end

    assert_redirected_to product_pictures_path
  end
end
