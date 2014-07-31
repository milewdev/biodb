json.array!(@skills) do |skill|
  json.extract! skill, :id, :job_id, :name, :group
  json.url skill_url(skill, format: :json)
end
