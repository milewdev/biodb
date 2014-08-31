class AddSortOrderToHighlights < ActiveRecord::Migration
  def change
    add_column :highlights, :sort_order, :integer
    add_index :highlights, [:user_id, :sort_order], :unique => true
  end
end
