json.array!(@jobs) do |job|
  json.extract! job, :id, :company, :synopsis, :title, :when
  json.url job_url(job, format: :json)
end
