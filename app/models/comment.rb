class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true

	has_many :comment_flags, dependent: :destroy  

	validates_inclusion_of :commentable_type, :in => ["Product", "Outfit"]
end
