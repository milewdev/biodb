json.array!(@highlights) do |highlight|
  json.extract! highlight, :id, :user_id, :content
  json.url user_highlight_url(@user, highlight, format: :json)
end
