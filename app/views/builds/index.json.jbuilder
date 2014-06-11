json.array!(@builds) do |build|
  json.extract! build, :id, :architecture_id, :builder_id, :recipe_id, :issued, :completed, :result
  json.url build_url(build, format: :json)
end
