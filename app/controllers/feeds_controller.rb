class FeedsController < ApplicationController
  before_filter :admin_required, :except => [:fetch_all, :fetch_next, :add, :create]

  # GET /feeds
  def index
    conditions = "approved = 1"
    conditions = ["#{conditions} AND UPPER(title) LIKE UPPER(?)", "%#{params[:search]}%"] if params[:search]
    @feeds = Feed.paginate :page => params[:page], :order => sort_order('last_fetched','down'), :conditions => conditions

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /feeds/pending
  def pending
    @feeds = Feed.paginate :page => params[:page], :order => sort_order('created_at','down'), :conditions => {:approved => 0}

    respond_to do |format|
      format.html # index.html.erb
    end
  end
    

  # GET /feeds/1
  # GET /feeds/1.xml
  def show
    @feed = Feed.find(params[:id])
    @entries = Entry.find(:all, :conditions => {:feed_id => params[:id]}, :order => "published desc")

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /feeds/new
  # GET /feeds/new.xml
  def new
    @feed = Feed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed }
    end
  end

  # GET /feeds/1/edit
  def edit
    @feed = Feed.find(params[:id])
  end

  # POST /feeds
  def create
    @feed = Feed.new(params[:feed])
    @feed.feed_url = TruffleHog.parse_feed_urls(Typhoeus::Request.get(params[:feed][:url]).body).first if params[:feed][:url] != ""

    respond_to do |format|
      if @feed.save
        format.html { 
          if !params[:add].nil?
            flash[:notice] = 'Su solicitud se ha enviado con éxito.<br />En unos instantes recibirá un mensaje de correo en su buzón con las instrucciones que debe seguir para continuar con el proceso de alta.'
            redirect_to(add_blog_path)
          else
            flash[:notice] = 'El blog se ha añadido correctamente.'
            redirect_to(@feed)
          end
        }
      else
        format.html {
          if !params[:add].nil?
            @feeds = Feed.all(:order => :title)
            render :layout => "pages", :action => "add"
          else
            render :action => "new"
          end
        }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.xml
  def update
    @feed = Feed.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        flash[:notice] = 'El blog se ha actualizado correctamente.'
        format.html { redirect_to(@feed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.xml
  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to(feeds_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /feeds/1/fetch
  def fetch
    @feed = Feed.find(params[:id])
    
    respond_to do |format|
      if @feed.fetch!
        flash[:notice] = "El blog se ha sincronizado correctamente"
      else
        flash[:error] = "Error al sincronizar el blog: #{@feed.last_error}"
      end
      format.html { redirect_to(@feed) }
    end
  end
  
  # GET /feeds/fetch_all
  def fetch_all
    Feed.fetch_all!
    
    respond_to do |format|
      flash[:notice] = "All feeds were fetched (successfully?...)"
      format.html { redirect_to(feeds_url)}
    end
  end
    
  # GET /feeds/fetch_next
  def fetch_next
    Feed.fetch_next!
    
    respond_to do |format|
      flash[:notice] = "Next feed were fetched (successfully?...)"
      format.html { redirect_to(feeds_url)}
    end
  end
  
  # GET /anade-tu-blog
  def add
    @feed = Feed.new
    @feeds = Feed.all(:order => :title)
    render :layout => "pages"
  end
  
  # PUT /feeds/1/approve
  def approve
    @feed = Feed.find(params[:id])
    
    respond_to do |format|
      @feed.approved = 1
      @feed.fetch!
      if @feed.save
        Notifier.deliver_feed_approved(@feed)
        flash[:notice] = "El blog se ha añadido correctamente"
        format.html { redirect_to(feeds_url)}
      else
        flash[:notice] = "No se ha podido añadir el blog. Revisa sus datos"
        format.html { redirect_to(edit_feed_path(@feed))}
      end
    end
  end
    
    
end
