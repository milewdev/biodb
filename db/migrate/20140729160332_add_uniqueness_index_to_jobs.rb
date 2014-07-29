class AddUniquenessIndexToJobs < ActiveRecord::Migration
  def change

    #
    # company + title + start_date must be unique.  This is enforced
    # in the model class Job, but we enforce it here as well for the
    # likely rare case where two duplicate records are entered by
    # different processes at the same time.
    #
    add_index :jobs, [:company, :title, :start_date], :unique => true

  end
end
