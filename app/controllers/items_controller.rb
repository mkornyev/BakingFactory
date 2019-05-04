class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_login, except: [:index, :show]
  authorize_resource
  
  def index
    # Search all items if :params present 
    if (params[:search].present?) && !(["bread","muffins","pastries","inactive"].include?(params[:search]))
      if logged_in? && current_user.role?(:admin)
        @all_items = Item.all.alphabetical.search_by(params[:search]).paginate(:page => params[:page]).per_page(6)
      else
        @all_items = Item.active.alphabetical.search_by(params[:search]).paginate(:page => params[:page]).per_page(6)
      end 
    # Categories
    elsif params[:search] == "bread"
      @all_items = Item.active.alphabetical.for_category('bread').paginate(:page => params[:page]).per_page(6)
    elsif params[:search] == "muffins"
      @all_items = Item.active.alphabetical.for_category('muffins').paginate(:page => params[:page]).per_page(6)
    elsif params[:search] == "pastries"
      @all_items = Item.active.alphabetical.for_category('pastries').paginate(:page => params[:page]).per_page(6)
    elsif params[:search] == "inactive" && logged_in? && current_user.role?(:admin)
      @all_items = Item.inactive.alphabetical.paginate(:page => params[:page]).per_page(6)
    else 
      @all_items = Item.active.alphabetical.paginate(:page => params[:page]).per_page(6)
      # @breads = Item.active.for_category('bread').alphabetical.search_by(params[:search]).paginate(:page => params[:page]).per_page(6)
      # @muffins = Item.active.for_category('muffins').alphabetical.search_by(params[:search]).paginate(:page => params[:page]).per_page(6)
      # @pastries = Item.active.for_category('pastries').alphabetical.search_by(params[:search]).paginate(:page => params[:page]).per_page(6)
      # # get a list of any inactive items for sidebar
      # @inactive_items = Item.inactive.alphabetical.search_by(params[:search]).paginate(:page => params[:page]).per_page(6)
    end
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