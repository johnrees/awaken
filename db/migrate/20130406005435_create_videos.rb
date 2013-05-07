class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :kind
      t.string :client
      t.integer :ordinal
      t.integer :width
      t.integer :height
      t.integer :filesize
      t.integer :duration
      t.string :attachment
      t.string :thumbnail
      t.string :zencoder_output_id
      t.boolean :processed, default: false
      t.timestamps
    end
    add_index :videos, :ordinal
  end
end
