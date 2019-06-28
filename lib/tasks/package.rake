namespace :package do
  desc 'Syncs the database of packages with a repo'
  task sync: :environment do
    require 'net/http'

    # Erase all known packages
    Package.destroy_all

    recipes = Recipe.all
    architectures = Architecture.all
    repositories = Repo.all

    repositories.each do |repo|
      url = URI.parse(repo[:url])
      puts repo[:name] + '...'
      recipes.each do |recipe|
        architectures.each do |arch|
          rev = recipe['revision'].to_i
          path = "#{url.path}/#{arch['name']}/current/packages"
          while rev.to_i > 0
            hpkgname = "#{recipe['name']}-#{recipe['version']}-#{rev}-#{arch['name']}.hpkg"
            puts "#{path}/#{hpkgname}"
            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true if url.scheme == 'https'
            response = http.request_head("#{path}/#{hpkgname}")
            break if response.code.to_i == 200
            rev -= 1
          end
          attributes = {
            recipe_id: recipe[:id],
            repo_id: repo[:id],
            architecture_id: arch[:id],
            latestrev: rev,
            path: nil
          }
          @package_new = Package.new(attributes)
          @package_new.save
        end
      end
    end
  end
end
