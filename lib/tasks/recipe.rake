namespace :recipe do
  desc "Syncs the applications database of recipes with haikuports"
  task sync: :environment do
    require 'find'

	puts "================================\n"
	puts "Syncing Application Database"
	puts Rails.application.config.haikuports

	local_recipes = []
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
				:revision => revision_info[:value],
				:category => category_info[:category],
				:filename => file,
			}
			local_recipes.push(recipe)
	        end
	end
	
	local_recipes.each do |attributes|
		puts "Adding recipe #{attributes[:name]}-#{attributes[:version]}-#{attributes[:revision]}"
		@new_entry = Recipe.new(attributes)
		@new_entry.save
	end

  end

  desc "Empties the applicaions database of recipes"
  task clear: :environment do
  end

end
