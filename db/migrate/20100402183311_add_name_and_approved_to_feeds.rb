class AddNameAndApprovedToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :name, :string
    add_column :feeds, :approved, :integer, :default => 0
    
    Feed.all.each do |feed|
      feed.name = "<Pendiente de asignar un nombre>"
      feed.email = "planeta@cordobapedia.org"
      feed.approved = 1
      if feed.save(false)
        puts "."
      else
        puts "x"
        puts feed.errors.full_messages
      end
    end
  end

  def self.down
    remove_column :feeds, :name
    remove_column :feeds, :approved
  end
end
