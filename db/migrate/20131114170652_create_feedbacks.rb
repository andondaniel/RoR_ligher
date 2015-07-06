class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :email
      t.text :content
      t.string :type
      t.string :status

      t.timestamps
    end
  end
end
