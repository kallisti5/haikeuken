module Buildmeister
  class Heartbeat < Grape::API
    desc "Worker heartbeat"
    params do
      requires :hostname, type: String
      requires :token, type: String
      requires :architecture, type: String
      requires :revision, type: String
      requires :platform, type: String
      requires :version, type: String
      #requires :uptime, type: String
    end
    post '/heartbeat/:hostname' do
      builder = Builder.find_by(hostname: params[:hostname])
      if !builder or params[:token] != builder['token']
        return {'Error' => 'Invalid access attempt!'}
      end
      builder.update(lastheard: Time.now)
      {'Success' => 'Hello!'}
	end
  end
end
