class Feed < ActiveRecord::Base
  has_many :entries, :dependent => :destroy
  #after_create :fetch!

  validates_presence_of :name, :url, :email
  validates_presence_of :feed_url
  validates_uniqueness_of :feed_url
  validates_format_of :url, :with => REXP_URL, :allow_nil => false, :allow_blank => false
  validates_format_of :feed_url, :with => REXP_URL, :allow_nil => false, :allow_blank => false
  validates_format_of :email, :with => REXP_EMAIL, :allow_blank => false
  
  cattr_reader :per_page
  @@per_page = 25

  #
  # Fetch feed, update attibutes and create entries
  #
  def fetch!(first=false)
    self.status = 0 if self.status.nil?
    begin
      parsed_feed = Feedzirra::Feed.fetch_and_parse(self.feed_url,
                               :etag => self.etag, 
                               :last_modified => self.last_modified)
      self.title = parsed_feed.title if !parsed_feed.title.nil?
      self.url = parsed_feed.url if !parsed_feed.url.nil?

      self.update_attributes( :etag => parsed_feed.etag,
                              :last_modified => parsed_feed.last_modified)

      parsed_feed.entries.first(10).each do |entry|
        if entry.published.nil?
          if first
            entry.published = 1.month.ago.to_s
          else
            entry.published = Time.now.to_s
          end
        end
        self.entries.create(:url => entry.url,
                            :title => entry.title,
                            :author => entry.author,
                            :summary => entry.summary,
                            :content => entry.content,
                            :published => entry.published) if !Entry.find_by_url(entry.url)
        self.status = 0
        self.last_error = nil
      end
    rescue Exception => e
      puts "ERROR: could not parse feed #{feed_url}"
      puts e.message
      self.last_error = e.message
      #puts e.backtrace.inspect
      self.status += 1
    end
    self.last_fetched = Time.now
    self.save
    if self.status != 0
      return false
    else
      return true
    end
  end
  
  #
  # Fetch all feeds
  #
  def self.fetch_all!(first=false)
    Feed.find(:all).each do |f|
      puts "Fetching #{f.feed_url}"
      f.fetch!(first) rescue nil
    end
  end  

  #
  # Fetch next feed
  #
  def self.fetch_next!
    Feed.all(:order => :last_fetched).first(5).each do |f| 
      puts "Fetching #{f.feed_url}"
      f.fetch! rescue nil
    end
  end 
  
  def self.all_approved
    Feed.all(:order => :title, :conditions => {:approved => 1})
  end
  
  def is_approved?
    self.approved > 0
  end

end
