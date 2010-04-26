class AddLastFetchedToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :last_fetched, :datetime
  end

  def self.down
    remove_column :feeds, :last_fetched
  end
end
