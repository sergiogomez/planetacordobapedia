class EntriesController < ApplicationController
  before_filter :admin_required, :except => [:rss]

  # GET /entries
  def index
    conditions = ["UPPER(title) LIKE UPPER(?)", "%#{params[:search]}%"] if params[:search]
    @entries = Entry.all(params[:page],sort_order('published','down'),conditions)
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /entries/rss
  def rss
    @entries = Entry.all_published('1')
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

  # GET /entries/1
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /entries/new
  # GET /entries/new.xml
  def new
    @entry = Entry.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  # POST /entries
  def create
    @entry = Entry.new(params[:entry])

    respond_to do |format|
      if @entry.save
        flash[:notice] = 'Entry was successfully created.'
        format.html { redirect_to(@entry) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /entries/1
  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:notice] = 'Entry was successfully updated.'
        format.html { redirect_to(@entry) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /entries/1
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to(entries_url) }
    end
  end
end
