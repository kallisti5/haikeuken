module V1
  class Work < Grape::API

    helpers do
      def validate_builder!
        builder = Builder.find_by(hostname: params[:hostname])
        if !builder or params[:token] != builder['token']
          # Invalid builder or token, redirect to root
          error!('401 Unauthorized', 401)
        end
        return builder
      end
    end

    desc 'Get Work'
    params do
      requires :hostname, type: String
      requires :token, type: String
    end
    # http://localhost:9292/api/v1/work/test?token=123
    get '/work/:hostname' do
      builder = validate_builder!

      build = nil

      if builder.busy
        build = builder.last_build
      else
        package = Package.joins(:recipe).where('packages.latestrev < recipes.revision').where(architecture: builder.architecture).first

        if package
          # Schedule the build for this builder
          build = Build.create(architecture: package.architecture,
            builder: builder, recipe: package.recipe, issued: Time.now,
            active: true)
        end
      end

      if build != nil
        # last seen built revision is outdated
        work = {
          id: build[:id],
          name: build.recipe[:name],
          version: build.recipe[:version],
          revision: build.recipe[:revision],
          architecture: build.architecture[:name]
        }
        return { 'command' => 'build', 'build' => work }
      else
        return { 'command' => 'none' }
      end
    end

    desc 'Post Work Results'
    params do
      requires :hostname, type: String
      requires :token, type: String
    end
    # http://localhost:9292/api/v1/work/test?token=123
    post '/work/:hostname' do
      builder = validate_builder!
      build = Build.find(params[:build_id])
      if !build
        error!('500 No build', 500)
      end

      build.update(active: false, result: params['result'], 
        completed: Time.now, details: params['details'])
 
      Rails.logger.info pp(params)
    end

  end
end
