class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :name
      t.string :kind
      t.string :client
      t.integer :ordinal, default: 0, null: false

      t.timestamps
    end
    add_index :videos, :ordinal
  end
end
