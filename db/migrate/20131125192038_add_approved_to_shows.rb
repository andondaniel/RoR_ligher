class AddApprovedToShows < ActiveRecord::Migration
  def change
    add_column :shows, :approved, :boolean

    Show.reset_column_information 

    shows = Show.unscoped.all

    shows.each do |s|
       s.approved = true
       s.save
    end
  end
end
