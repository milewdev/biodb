class AddHighlightsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :highlights, :text
  end
end
