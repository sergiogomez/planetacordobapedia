class Entry < ActiveRecord::Base
  belongs_to :feed
  
  validates_presence_of :feed_id, :url
  validates_uniqueness_of :url
  
  cattr_reader :per_page
  @@per_page = 25
  
  def self.all(page,order,conditions)
    Entry.paginate :page => page, :order => order, :conditions => conditions
  end
  
  def self.all_published(page)
    Entry.paginate :page => page, :order => "published desc", :conditions => ["published <= '#{Time.now.getgm.xmlschema()}'"]
  end
  
end
