json.array!(@recipes) do |recipe|
  json.extract! recipe, :id, :name, :version, :revision, :filename
  json.url recipe_url(recipe, format: :json)
end
