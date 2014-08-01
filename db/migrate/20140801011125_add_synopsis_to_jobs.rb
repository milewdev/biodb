class AddSynopsisToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :synopsis, :text
  end
end
