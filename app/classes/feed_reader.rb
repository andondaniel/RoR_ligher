class FeedReader
	attr_accessor :feed


	def feed=(url)
    @feed = Feedjira::Feed.fetch_and_parse(url)
  end

  #feed.url
  #feed.title
  #feed.entries #individual posts
  	#feed.entries.limit(3).each do |post|
  		#post.entry_id  		##url of the post
  		#post.summary   		##html summary of the post (~2 sentences)
  		#post.author    		##text of author's name
  		#post.categories 		##returns array of the tagged categories of the blog post


end