require 'test_helper'

class ProductSourcesControllerTest < ActionController::TestCase
  setup do
    @product_source = product_sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_source" do
    assert_difference('ProductSource.count') do
      post :create, product_source: { price: @product_source.price, product_id: @product_source.product_id, status: @product_source.status, store_id: @product_source.store_id, url: @product_source.url }
    end

    assert_redirected_to product_source_path(assigns(:product_source))
  end

  test "should show product_source" do
    get :show, id: @product_source
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_source
    assert_response :success
  end

  test "should update product_source" do
    patch :update, id: @product_source, product_source: { price: @product_source.price, product_id: @product_source.product_id, status: @product_source.status, store_id: @product_source.store_id, url: @product_source.url }
    assert_redirected_to product_source_path(assigns(:product_source))
  end

  test "should destroy product_source" do
    assert_difference('ProductSource.count', -1) do
      delete :destroy, id: @product_source
    end

    assert_redirected_to product_sources_path
  end
end
