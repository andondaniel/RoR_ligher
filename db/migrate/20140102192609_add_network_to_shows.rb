class AddNetworkToShows < ActiveRecord::Migration
  def change
    add_reference :shows, :network, index: true
  end
end
