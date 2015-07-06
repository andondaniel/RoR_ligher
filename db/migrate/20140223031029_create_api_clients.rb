class CreateAPIClients < ActiveRecord::Migration
  def change
    create_table :api_clients do |t|
      t.string :name
      t.text :description
      t.string :app_token
      t.boolean :valid

      t.timestamps
    end
  end
end
