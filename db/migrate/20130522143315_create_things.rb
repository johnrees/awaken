class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.integer :initial_position

      t.timestamps
    end
  end
end
