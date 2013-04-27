class Admin::PagesController < ApplicationController

  layout "admin"
  def index
    @pages = Page.all
  end

  def show
    @page = Page.find_by_permalink(params[:id])
  end

  def new
    @page = Page.new
  end

  def edit
    @page = Page.find_by_permalink(params[:id])
  end

  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @page = Page.find_by_permalink(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @page = Page.find_by_permalink(params[:id])
    @page.destroy

    redirect_to admin_pages_url
    # format.json { head :no_content }
  end

end
