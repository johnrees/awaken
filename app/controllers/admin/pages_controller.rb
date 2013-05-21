class Admin::PagesController < ApplicationController

  layout "admin"

  def index
    @pages = Page.all
  end

  def sort
    order = params[:page]
    Page.do_order(order)
    render :text => order.inspect
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
      redirect_to admin_pages_url, notice: 'Page added'
    else
      render action: "new"
    end
  end

  def update
    @page = Page.find_by_permalink(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to admin_pages_url, notice: 'Page Updated'
    else
      render action: "edit"
    end
  end

  def destroy
    @page = Page.find_by_permalink(params[:id])
    @page.destroy

    redirect_to admin_pages_url, notice: 'Page Destroyed'
  end

end
