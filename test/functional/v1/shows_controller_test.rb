require 'test_helper'
module API
	module V1
		class ShowsControllerTest <ActionController::TestCase
			setup do
				@show = shows(:one)
			end

			test "should get index" do
				get :index, :format => 'json'
				assert_response :success
			end

			test "should create show" do
				assert_difference('Show.count') do
					post :create, show: { name: "test_show" }, :format => 'json'
				end

				assert_response 201
			end

			test "should show show" do
				get :show, id: @show.slug, :format => 'json'
				assert_response :success
			end

			test "should update show" do
				put :update, id: @show, show: { id: @show.slug }, :format => 'json'
				assert_response 204
			end

			test "should destroy show" do
				assert_difference('Show.count', -1) do
	        delete :destroy, id: @show, :format => 'json'
	      end

	      assert_response 204
	    end

	  end
	end
end