module ProductsHelper

	def last_worn_in(p)
		"Last Worn In Season #{p.last_episode.season} Episode #{p.last_episode.episode_number}"
	end

	
end
