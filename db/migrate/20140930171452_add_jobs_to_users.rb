class AddJobsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :jobs, :text
  end
end
