class FeedObserver < ActiveRecord::Observer
  def after_create(feed)
    Notifier.deliver_feed_added(feed)
  end
end