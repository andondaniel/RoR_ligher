require 'test_helper'

class EpisodeLinksControllerTest < ActionController::TestCase
  setup do
    @episode_link = episode_links(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:episode_links)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create episode_link" do
    assert_difference('EpisodeLink.count') do
      post :create, episode_link: { alt_text: @episode_link.alt_text, episode_id: @episode_link.episode_id, title: @episode_link.title, url: @episode_link.url }
    end

    assert_redirected_to episode_link_path(assigns(:episode_link))
  end

  test "should show episode_link" do
    get :show, id: @episode_link
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @episode_link
    assert_response :success
  end

  test "should update episode_link" do
    patch :update, id: @episode_link, episode_link: { alt_text: @episode_link.alt_text, episode_id: @episode_link.episode_id, title: @episode_link.title, url: @episode_link.url }
    assert_redirected_to episode_link_path(assigns(:episode_link))
  end

  test "should destroy episode_link" do
    assert_difference('EpisodeLink.count', -1) do
      delete :destroy, id: @episode_link
    end

    assert_redirected_to episode_links_path
  end
end
