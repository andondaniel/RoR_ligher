module Feedjira
  module Parser
    # It's good practice to namespace your parsers, so we'll put
    # this one in the Versa namespace.
    module Custom
    
      ### Entry Parser Class ###
      # This first class is for parsing an individual <item> in the feed.
      # We define it first because our top level parser need to be able to call it.
      # By convention, this class name is the same as our top level parser
      # but with "Entry" appended.
      class LumiereEntry
        include SAXMachine
        include FeedEntryUtilities
 
        # Declare the fields we want to parse out of the XML feed.
        element :title
        element :link, :as => :url
        element :author
        element :description, :as => :summary
        element :pubDate, :as => :published
        element :guid, :as => :entry_id
        element :imageUrl, :as => :image
        
      end
      
      
      ### Feed Parser Class ###
      # This class is for parsing the top level feed fields.
      class Lumiere
        include SAXMachine
        include FeedUtilities
        
        # Define the fields we want to parse using SAX Machine declarations
        element :title
        element :link, :as => :url
        
        # Parse all the <item>s in the feed with the class we just defined above
        elements :item, :as => :entries, :class => Custom::LumiereEntry
 
        attr_accessor :feed_url
 
        # This method is required by all Feedjira parsers. To decide which
        # parser to use, Feedjira cycles through each parser it knows about
        # and passes the first 2000 characters of the feed to this method.
        # 
        # To make sure your parser is only used when it's supposed to be used,
        # test for something unique in those first 2000 characters. URLs seem
        # to be a good choice.
        #
        # This parser, for example, is looking for an occurrence of
        # '<link>https://www.jankybutlovablepublisher.com' which we should
        # only really find in the feed we are targeting.
        def self.able_to_parse?(xml)
          (/<link>http:\/\/blog\.spylight\.com\// =~ xml)
        end
      end
    end
  end
end