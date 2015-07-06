module ImageValidator

	def get_dimensions
		if avatar.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(avatar.queued_for_write[:original].path)
    #added to make sure avatar original wasn't just returning the default missing png
    elsif avatar(:original) && (avatar(:original) != "/avatars/original/missing.png")
      avatar_path = (avatar.options[:storage] == :s3) ? avatar.url(:original) : avatar.path(:original)
      dimensions = Paperclip::Geometry.from_file(avatar_path)
    end
    return dimensions
	end

	#the styles hash will have have all styles with their required dimensions

	#width_valid? {cover: 1000}
	def width_validator styles_hash, general_minimum = nil
		dimensions = get_dimensions
		if dimensions
			styles_hash.each_pair do |style, required_width|
				if self.send(style)
					if dimensions.width < required_width
						errors.add(:file, "Width for #{style} image must be at least #{required_width}px")
					end
				end
			end
			if general_minimum
				if dimensions.width < general_minimum
					errors.add(:file, "Width for all styles must be at least #{general_minimum}px")
				end
			end
		end
	end

	def heigth_validator styles_hash, general_minimum = nil
		dimensions = get_dimensions
		if dimensions
			styles_hash.each_pair do |style, required_height|
				if self.send(style)
					if dimensions.height < required_height
						errors.add(:file, "Height for #{style} image must be at least #{required_height}px")
					end
				end
			end
			if general_minimum
				if dimensions.height < general_minimum
					errors.add(:file, "Height for all styles must be at least #{general_minimum}px")
				end
			end
		end
	end

	def ratio_validator styles_hash, general_ratio = nil
		dimensions = get_dimensions
		if dimensions
			styles_hash.each_pair do |style, required_ratio|
				if self.send(style)
					if (dimensions.width / dimensions.height != required_ratio)
						errors.add(:file, "The width to height ratio for #{style} images must be #{required_ratio}")
					end
				end
			end
			if general_ratio
				if (dimensions.width / dimensions.height != general_ratio)
					errors.add(:file, "The width to height ratio must be #{general_ratio}")
				end
			end
		end
	end

end
