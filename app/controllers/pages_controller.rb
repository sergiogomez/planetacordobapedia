class PagesController < ApplicationController

  # http://blog.daviddollar.org/2009/08/22/static-pages-in-rails.html
  rescue_from ActionView::MissingTemplate, :with => :invalid_page
  
  def index
    get_entries(params[:page])
    get_feeds
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    get_entries(params[:page])
    get_feeds
    render params[:id]
  end
  
  def invalid_page
    redirect_to root_path
  end
  
  def redirect_to_feedburner
    redirect_to "http://feeds2.feedburner.com/Planetacordobapediaorg", :status => 301
  end
  
  private
  
  def get_entries(page)
    @entries = Entry.all_published(page)
  end
  
  def get_feeds
    @feeds = Feed.all_approved
  end

end
