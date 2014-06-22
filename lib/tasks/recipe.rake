namespace :recipe do
  desc "Syncs the applications database of recipes with haikuports"
  task sync: :environment do
    require 'find'

	puts "================================\n"
	puts "Syncing Haikuports with database"
	puts Rails.application.config.haikuports

	repo_recipes = []
	Find.find(Rails.application.config.haikuports) do |path_file|
		file_name = File.basename(path_file)
		if file_name =~ /^.*-.*\.recipe$/
		    recipe_file = File.basename(path_file, ".recipe")
		    name_info = /^(?<name>\S*)-(?<version>.*)$/.match(recipe_file)

			revision_line = File.readlines(path_file).select{|l| l.match /^REVISION=/}.last
			revision_info = /^REVISION\s?=\s?\"?(?<value>\d+)\"?$/.match(revision_line)
			if revision_info == nil
				revision_info = { :value => 0 }
			end
	
			file = path_file.gsub(Rails.application.config.haikuports, "")
			category_info = /^\/(?<category>\S*)\/\S*\/\S*$/.match(file)

			recipe = {
				:name => name_info[:name],
				:version => name_info[:version],
				:revision => revision_info[:value].to_i,
				:category => category_info[:category],
				:filename => file,
			}
			repo_recipes.push(recipe)
	        end
	end
	
	db_recipes = Recipe.all
	repo_recipes.each do | repo_attributes |
		db_known = db_recipes.find_by(name: repo_attributes[:name], version: repo_attributes[:version])
		if db_recipes.count == 0 || !db_known
			puts "Adding recipe #{repo_attributes[:name]}-#{repo_attributes[:version]}-#{repo_attributes[:revision]}"
			new_entry = Recipe.new(repo_attributes)
			new_entry.save
		else
			if db_known[:revision] != repo_attributes[:revision]
				puts "Recipe #{repo_attributes[:name]}-#{repo_attributes[:version]} saw a revision change from '#{db_known[:revision]}' to '#{repo_attributes[:revision]}'"
				db_known[:revision] = repo_attributes[:revision]
				db_known.save
			end
		end
	end

  end

  desc "Performs a lint scan of the current recipes"
  task lint: :environment do
    puts "================================\n"
    puts "Running lint on recipies"
    require 'open4'
    Lint.destroy_all
    @recipes = Recipe.all
    lint_results = []
    @recipes.each do |recipe|
        puts "Running lint on #{recipe[:name]}-#{recipe[:version]}-#{recipe[:revision]}"
        pid, stdin, stdout, stderr = Open4.popen4("#{Rails.application.config.haikuporter}" \
            " --config=#{Rails.application.config.haikuporter_conf} " \
            " --lint #{recipe[:name]}-#{recipe[:version]}")
        ignored, status = Process::waitpid2 pid

        lint_result = {
            :recipe_id => recipe[:id],
            :clean => status.to_i == 0 ? TRUE : FALSE,
            :result => stdout.read.strip.gsub(/\n/, '<br>')
        }
		@new_entry = Lint.new(lint_result)
		@new_entry.save

        #lint_results.push(lint_result)
    end

	lint_results.each do |attributes|
		@new_entry = Lint.new(attributes)
		@new_entry.save
	end
  end

  desc "Empties the applicaions database of recipes"
  task clear: :environment do
  end

end
