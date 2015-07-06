class PropScene < ActiveRecord::Base
	self.table_name = "props_scenes"
  belongs_to :prop
  belongs_to :scene

  scope :exact_match, -> { where(exact_match: true) }

end
