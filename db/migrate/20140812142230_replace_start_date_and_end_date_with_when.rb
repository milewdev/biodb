class ReplaceStartDateAndEndDateWithWhen < ActiveRecord::Migration
  def change
    remove_column :jobs, :start_date, :date
    remove_column :jobs, :end_date, :date
    add_column :jobs, :when, :string
  end
end
