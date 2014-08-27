json.array!(@highlights) do |highlight|
  json.extract! highlight, :id, :user_id, :content
  json.url highlight_url(highlight, format: :json)
end
