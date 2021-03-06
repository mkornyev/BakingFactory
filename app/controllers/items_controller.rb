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
    end
  end

  def show
    if params[:new_price].present?
      item_price = ItemPrice.new
      item_price.item_id = @item.id 
      item_price.price = params[:new_price]
      item_price.save!
    end

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
    # Avoid a FK constraint error here (due to ItemPrice and OrderItem dependencies)
    @item.destroy
    redirect_to items_url, notice: "#{@item.name} was removed from the system."
  end

  def toggle
    # Toggle Check
    if params[:item_id].present? 
      path_var = request.referrer.split("/").last
      item = Item.find(params[:item_id])

      if item.active 
        item.make_inactive
        if path_var == "items" || path_var.include?("page")
          redirect_to items_path, notice: "Item made inactive."
        else 
          redirect_to item_path(Item.where(id: params[:item_id]).take), notice: "Item made inactive."
        end
      else 
        item.make_active 
        if path_var == "items" || path_var.include?("page")
          redirect_to items_path, notice: "Item made active."
        else 
          redirect_to item_path(Item.where(id: params[:item_id]).take), notice: "Item made active."
        end
      end
    end 
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :picture, :category, :units_per_item, :weight, :active)
  end

end