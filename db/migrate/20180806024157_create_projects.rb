class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :owner
      t.string :url
      t.integer :num_stars

      t.timestamps null: false
    end
  end
end
