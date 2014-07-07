json.array!(@items) do |item|
  json.extract! item, :id, :title, :path, :description, :breed
  json.url item_url(item, format: :json)
end
