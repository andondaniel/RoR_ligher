require 'spec_helper'

describe ProductSource do

  it 'product source should be valid' do
    FactoryGirl.create(:product_source, new_price_value: Faker::Number.number(4), new_price_currency: Faker::Number.number(2)).should be_valid
  end

end