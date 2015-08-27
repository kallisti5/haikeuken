module V1
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
        error!('401 Unauthorized', 401)
      end
      arch = Architecture.find_by(name: params[:architecture])
      # TODO: If architecture changes, raise event?
      # TODO: If osbuild changes, raise event?
      builder.update(lastheard: Time.now, osbuild: params[:revision], architecture_id: arch[:id])
	end
  end
end
