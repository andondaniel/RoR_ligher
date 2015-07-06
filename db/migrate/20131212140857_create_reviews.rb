class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :reviewer
      t.references :review_item, polymorphic: true
    end
  end
end
