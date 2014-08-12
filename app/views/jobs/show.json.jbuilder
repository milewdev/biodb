json.extract! @job, :id, :company, :title, :synopsis, :start_date, :end_date, :created_at, :updated_at
json.url job_url(@job, format: :json)
