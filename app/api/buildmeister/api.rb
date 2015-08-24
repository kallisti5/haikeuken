module Buildmeister
	class API < Grape::API
		version 'v1', using: :path
		format :json
		prefix :api
		mount Buildmeister::Work
	end
end
