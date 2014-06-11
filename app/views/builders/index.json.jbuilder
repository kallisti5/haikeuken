json.array!(@builders) do |builder|
  json.extract! builder, :id, :architecture_id, :hostname, :owner, :location, :lastheard, :token
  json.url builder_url(builder, format: :json)
end
