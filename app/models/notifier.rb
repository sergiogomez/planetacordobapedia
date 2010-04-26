class Notifier < ActionMailer::Base
  def feed_added(feed)
    recipients  "#{feed.name} <#{feed.email}>"
    from        "Planeta Cordobapedia <planeta@cordobapedia.org>"
    subject     "Añadir blog al Planeta Cordobapedia"
    sent_on     Time.now
    body        :feed => feed
  end
  def feed_approved(feed)
    recipients  "#{feed.name} <#{feed.email}>"
    from        "Planeta Cordobapedia <planeta@cordobapedia.org>"
    subject     "Re: Añadir blog al Planeta Cordobapedia"
    sent_on     Time.now
    body        :feed => feed
  end
end
