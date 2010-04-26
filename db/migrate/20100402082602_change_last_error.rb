class ChangeLastError < ActiveRecord::Migration
  def self.up
    change_column :feeds, :last_error, :text, :limit => nil
  end

  def self.down
    change_column :feeds, :last_error, :string
  end
end
