json.array!(@recipes) do |recipe|
  json.extract! recipe, :name, :preparation_time, :roasting_time, :quantity, :url, :user_id
  json.url recipe_url(recipe, format: :json)
end