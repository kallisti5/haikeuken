json.array!(@lints) do |lint|
  json.extract! lint, :id, :clean, :result
  json.url lint_url(lint, format: :json)
end
