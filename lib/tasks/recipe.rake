namespace :recipe do
  desc "Syncs the applications database of recipes with haikuports"
  task sync: :environment do
    require 'find'

	porter_config = [ "TREE_PATH=\"#{Rails.root.join("tmp")}/repos/ports.git\"\n",
		"PACKAGER=\"Haiku Kitchen <admin@haikungfu.net>\"\n",
		"TARGET_ARCHITECTURE=\"x86\"\n",
		"LICENSES_DIRECTORY=\"/srv/repos/haiku/data/system/data/licenses\"\n" ]

	File.open("#{Rails.root.join("tmp")}/ports.conf", "w") do |f|
		porter_config.each do |row| f << row end
	end

	puts "================================"
	puts "Syncing database with Haikuports"
	puts "================================"
	puts "Repo: #{Rails.application.config.haikuports}"

	Dir.mkdir("#{Rails.root.join("tmp")}/repos") unless File.directory?("#{Rails.root.join("tmp")}/repos")

	puts "Refreshing Haikuports tree..."
	begin
		haikuports = Git.open("#{Rails.root.join("tmp")}/repos/ports.git")
	rescue
		puts "No cached port repo found, cloning..."
		haikuports = Git.clone(Rails.application.config.haikuports,
			"#{Rails.root.join("tmp")}/repos/ports.git", :bare => false)
	end

	puts "Refreshing Haikuporter..."
	begin
		haikuporter = Git.open("#{Rails.root.join("tmp")}/repos/porter.git")
	rescue
		puts "No cached porter repo found, cloning..."
		haikuporter = Git.clone(Rails.application.config.haikuporter,
			"#{Rails.root.join("tmp")}/repos/porter.git", :bare => false)
	end
	puts "Pulling upstream port updates..."
	haikuporter.pull

	puts "Searching tree for updates / changes..."
	repo_recipes = []
	Find.find(haikuports.dir.to_s) do |path_file|
		file_name = File.basename(path_file)
		if file_name =~ /^.*-.*\.recipe$/
		    recipe_file = File.basename(path_file, ".recipe")
		    name_info = /^(?<name>\S*)-(?<version>.*)$/.match(recipe_file)

			revision_line = File.readlines(path_file).select{|l| l.match /^REVISION=/}.last
			revision_info = /^REVISION\s?=\s?\"?(?<value>\d+)\"\s*$/.match(revision_line)
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
			puts "Add new recipe #{repo_attributes[:name]}-#{repo_attributes[:version]}-#{repo_attributes[:revision]}"
			new_entry = Recipe.new(repo_attributes)
			new_entry.save
		else
			if db_known[:revision] != repo_attributes[:revision]
				puts "Update known recipe #{repo_attributes[:name]}-#{repo_attributes[:version]} from revison '#{db_known[:revision]}' to revision '#{repo_attributes[:revision]}'"
				db_known[:revision] = repo_attributes[:revision]
				db_known.save
			end
		end
	end

  end

  desc "Performs a lint scan of the current recipes"
  task lint: :environment do
	puts "================================"
    puts "Running lint on recipies"
	puts "================================"
	puts "Repo: #{Rails.application.config.haikuports}"
	puts "Porter: #{Rails.application.config.haikuporter}"

    require 'open4'
    @recipes = Recipe.all
    @recipes.each do |recipe|
        puts "Running lint on #{recipe[:name]}-#{recipe[:version]}-#{recipe[:revision]}"
        pid, stdin, stdout, stderr = Open4.popen4("#{Rails.root.join("tmp")}/repos/porter.git/haikuporter" \
            " --config=#{Rails.root.join("tmp")}/ports.conf" \
            " --lint #{recipe[:name]}-#{recipe[:version]}")
        ignored, status = Process::waitpid2 pid

		recipe.update(lintret: status.to_i)
		recipe.update(lint: stdout.read.strip.gsub(/\n/, '<br>'))
    end
  end

  desc "Empties the applicaions database of recipes"
  task clear: :environment do
  end

end
