namespace :builder do
  desc 'Provision a new builder'
  task :new, [:hostname, :location, :owner] => :environment do |_task, args|
    token = rand(36**64).to_s(36)
    Builder.create(hostname: args.hostname, token: token, owner: args.owner, location: args.location)
    puts 'general:'
    puts "  work_path: \"/boot/home/build\""
    puts "  token: \"#{token}\""
    puts "  hostname: \"#{args.hostname}\""
    puts 'sever:'
    puts "  url: \"SETME\""
  end

  desc 'Destroy a builder'
  task :destroy, [:hostname] => :environment do |_task, args|
    Builder.find_by(hostname: args.hostname).destroy
  end
end
