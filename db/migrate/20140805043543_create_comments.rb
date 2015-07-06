class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :commentable, index: true
      t.string :commentable_type, index: true
      t.string :body

      t.timestamps
    end
  end
end
