shows
  has_many characters
  has_many episodes
  name

episodes
  season
  episode_number
  name
  airdate
  belongs_to show
  has_many episode_links
  has_many products

episode_links
  url
  title
  alt_text
  belongs_to episode

scenes
  start_time
  end_time
  has_many scene_appearances

scene_appearances
  start_time
  end_time
  belongs_to product
  belongs_to scene

characters
  name
  belongs_to show
  has_many products
  has_many character_images

character_images
  has_attached_image
  url
  alt_text
  primary
  belongs_to character

products
  name
  description
  qr_code
  approved
  belongs_to episode
  belongs_to character
  belongs_to brand
  has_many product_pictures
  has_many product_sources
  has_many scene_appearances
  habtm product_categories
  habtm colors

product_picture
  has_attached_image
  url
  alt_text
  belongs_to product

product_source
  url
  price
  status
  belongs_to store
  belongs_to product

stores
  name
  has_many products, through: product_sources

colors
  name
  color_code
  habtm products

product_category
  name
  habtm products

brands
  name
  has_many products