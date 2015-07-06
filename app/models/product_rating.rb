class ProductRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates_inclusion_of :value, :in => (0..5)
  validates_uniqueness_of :product_id, scope: [:user_id]
end
