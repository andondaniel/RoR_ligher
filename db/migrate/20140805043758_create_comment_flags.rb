class CreateCommentFlags < ActiveRecord::Migration
  def change
    create_table :comment_flags do |t|
      t.references :comment, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
