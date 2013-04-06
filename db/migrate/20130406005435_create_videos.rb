class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :kind
      t.string :client

      t.timestamps
    end
  end
end
