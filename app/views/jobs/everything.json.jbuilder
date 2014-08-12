json.array!(@jobs) do |job|

  json.extract! job, :id, :company, :synopsis, :title, :when
  json.url job_url(job, format: :json)
  
  json.array(job.skills) do |skill|
    json.extract! skill, :id, :job_id, :name, :group, :created_at, :updated_at
    json.url job_skill_url(job, skill, format: :json)
  end
  
end
