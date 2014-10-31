namespace :build do
  desc "Cleans up builds that have timed out"
  task clean: :environment do
    now = Time.now
    Build.where(completed: nil).each do |build|
      if now.to_i - build.issued.to_i > 43200
        puts "#{build.recipe[:name]} has expired, removing..."
        build.destroy
      end
    end
  end
end
