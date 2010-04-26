class AddStatusToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :status, :integer
  end

  def self.down
    remove_column :feeds, :status
  end
end
