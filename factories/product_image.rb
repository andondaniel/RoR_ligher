include ActionDispatch::TestProcess 

FactoryGirl.define do

	factory :product_image do
    avatar { File.open(Rails.root.join('spec', 'images', 'product_image.jpg')) }
	end


end