json.extract! @job, :id, :company, :title, :synopsis, :when, :created_at, :updated_at
json.url job_url(@job, format: :json)
