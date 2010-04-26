class AddLastErrorToFeeds < ActiveRecord::Migration
  def self.up
    add_column :feeds, :last_error, :string
  end

  def self.down
    remove_column :feeds, :last_error
  end
end
