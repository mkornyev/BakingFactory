  class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_login, except: [:index, :show]
  authorize_resource
  
  def index
    # get info on active items for the big three...
    @all_items = Item.active.alphabetical.text_search(params[:query]).paginate(:page => params[:page]).per_page(4)
    @breads = Item.active.for_category('bread').alphabetical.paginate(:page => params[:page]).per_page(10)
    @muffins = Item.active.for_category('muffins').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pastries = Item.active.for_category('pastries').alphabetical.paginate(:page => params[:page]).per_page(10)
    # get a list of any inactive items for sidebar
    @inactive_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    if logged_in? && current_user.role?(:admin)
      # admin gets a price history in the sidebar
      @previous_prices = @item.item_prices.chronological.to_a
    end
    # everyone sees similar items in the sidebar
    @similar_items = Item.for_category(@item.category).alphabetical.to_a
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item, notice: "#{@item.name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "#{@item.name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "#{@item.name} was removed from the system."
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active)
  end

end