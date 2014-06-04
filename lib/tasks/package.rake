namespace :package do
    desc "Syncs the database of packages with a repo"
    task sync: :environment do
        require 'net/http'

        recipes = Recipe.all
        architectures = Architecture.all
        repositories = Repo.all

        repositories.each do |repo|
            puts repo[:name] + "..."
            recipes.each do |recipe|
                architectures.each do |arch|
                    rev = recipe['revision'].to_i
                    while rev.to_i > 0
                        hpkgname = "#{recipe['name']}-#{recipe['version']}-#{rev}-#{arch['name']}.hpkg"
                        puts hpkgname
                        response = Net::HTTP.start('packages.haiku-os.org', 80) do |http|
                            http.request_head("/haikuports/master/repo/#{arch['name']}/current/packages/#{hpkgname}")
                        end
                        break if response.code.to_i == 200
                        rev -= 1
                    end
                    attributes = {
                        :recipe_id => recipe[:id],
                        :repo_id => repo[:id],
                        :architecture_id => arch[:id],
                        :latestrev => rev,
                        :path => nil
                    }
                    @package_new = Package.new(attributes)
                    @package_new.save
                end
            end
        end
    end
end
