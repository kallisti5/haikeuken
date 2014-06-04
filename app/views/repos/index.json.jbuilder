json.array!(@repos) do |repo|
  json.extract! repo, :id, :name, :url, :lastrefresh
  json.url repo_url(repo, format: :json)
end
