class AddOrdinalToPages < ActiveRecord::Migration
  def change
    add_column :pages, :ordinal, :integer
    add_index :pages, :ordinal
  end
end
