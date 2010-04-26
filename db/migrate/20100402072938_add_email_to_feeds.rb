class AddEmailToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :email, :string

    Feed.all.each do |feed|
      feed.email = "planeta@cordobapedia.org"
      if feed.save(false)
        puts "."
      else
        puts "x"
        puts feed.errors.full_messages
      end
    end
  end

  def self.down
    remove_column :feeds, :email
  end
end
