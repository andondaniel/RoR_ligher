class AddAvatarsToQuizImageModels < ActiveRecord::Migration
  def change
    add_attachment :quiz_images, :avatar
    add_attachment :option_images, :avatar
    add_attachment :result_images, :avatar
  end
end
