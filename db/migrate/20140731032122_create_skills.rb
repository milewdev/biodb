class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.belongs_to :job, index: true
      t.string :name
      t.string :group

      t.timestamps
    end
    
    #
    # name + group must be unique for each job.  This is enforced
    # in the model class Job, but we enforce it here as well for the
    # likely rare case where two duplicate records are entered by
    # different processes at the same time.
    #
    add_index :skills, [:job_id, :name], :unique => true

  end
end
