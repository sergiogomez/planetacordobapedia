namespace :pc do
  namespace :fetch do
    desc "Fetch all feeds"
    task :all => :environment do |t|
      puts "Fetching all feeds, please wait..."
      Feed.fetch_all!
      puts "Done!"
    end
    desc "Fetch next feed"
    task :next => :environment do |t|
      t = Time.now
      puts "Fetching next feed, please wait..."
      Feed.fetch_next!
      puts "Done!"
      puts Time.now - t
    end
    desc "Fetch all feeds for first time"
    task :all_first => :environment do |t|
      puts "Fetching all feeds, please wait..."
      Feed.fetch_all!(true)
      puts "Done!"
    end
  end
  namespace :delete do
    desc "Delete all entries"
    task :entries => :environment do |t|
      puts "Deleting all entries, please wait..."
      entries = Entry.all
      entries.each do |entry|
        entry.destroy
      end
    end
    desc "Delete all feeds"
    task :feeds => :environment do |t|
      puts "Deleting all feeds, please wait..."
      feeds = Feed.all
      feeds.each do |feed|
        feed.destroy
      end
    end
  end
end