namespace :recipe do
  desc "Syncs the applications database of recipes with haikuports"
  task sync: :environment do
	puts "================================\n"
	puts "Syncing Application Database"
	[
		{ :name => "Package A", :version => "1.0.0", :revision => 1 },
		{ :name => "Package B", :version => "1.0.0", :revision => 1 },
		{ :name => "Package C", :version => "1.0.0", :revision => 1 },
    ].each do |attributes|
		puts "Adding recipe #{attributes[:name]}"
		@recipe = Recipe.new(attributes)
		@recipe.save
    end
  end

  desc "Empties the applicaions database of recipes"
  task clear: :environment do
  end

end
