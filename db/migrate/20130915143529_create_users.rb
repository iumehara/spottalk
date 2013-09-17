class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :location_id
      t.float :lat
      t.float :long
      t.timestamps
    end
  end
end
