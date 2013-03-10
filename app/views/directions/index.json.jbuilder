json.array!(@directions) do |direction|
  json.extract! direction, :name, :position, :recipe_id
  json.url direction_url(direction, format: :json)
end