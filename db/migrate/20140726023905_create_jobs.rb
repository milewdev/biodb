class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :company
      t.string :title
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
