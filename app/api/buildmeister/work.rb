module Buildmeister
  class Work < Grape::API
    desc "Get Work"
	params do
      requires :hostname, type: String
      requires :token, type: String
    end
	# http://localhost:9292/api/v1/work/test?token=123
    # XXX: This should be a post
    get '/work/:hostname' do
      builder = Builder.find_by(hostname: params[:hostname])
      if !builder or params[:token] != builder['token']
        # Invalid builder or token, redirect to root
        return {'Error' => 'Invalid access attempt!'}
      end

      builder.update(:lastheard => Time.now)

      workitems = []
      Package.joins(:recipe).where("packages.latestrev < recipes.revision").where(architecture: builder.architecture).each do |package|

        # Limit to one workitem for now
        # Could this be done in the query?
        next if workitems.count > 0
        next if Build.where(recipe: package.recipe).where(completed: nil).count > 0

        # Schedule the build for this builder
        build = Build.create(architecture: package.architecture,
          builder: builder, recipe: package.recipe, issued: Time.now,
          status: "Building")

        # last seen built revision is outdated
        # add work to tasks
        task = {
          :id => build[:id],
          :name => package.recipe[:name],
          :version => package.recipe[:version],
          :revision => package.recipe[:revision],
          :architecture => builder.architecture[:name]
        }
        workitems.push(task)
      end

      workitems
    end
  end
end
