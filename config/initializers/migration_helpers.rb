ActiveRecord::Migration.class_eval do
  def view_sql(timestamp,view)
    File.read(Rails.root.join("db/views/#{view}/#{timestamp}_#{view}.sql"))
  end
end