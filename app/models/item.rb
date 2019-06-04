class Item < ApplicationRecord
  # REQUIRED EDIT: 
  # Make item price a required field

  # get modules to help with some functionality
  include AppHelpers::Validations
  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # Searchability 
  def self.search_by(term)
    where(["LOWER(name) LIKE :term OR  LOWER(description) LIKE :term", { term: "%#{term.downcase}%", term: "%#{term.downcase}%" }])
  end

  # List of allowable categories
  CATEGORIES = [['Bread','bread'],['Muffins','muffins'],['Pastries','pastries']]

  # Relationships
  has_many :order_items
  has_many :item_prices
  has_many :orders, through: :order_items

  # Scopes
  scope :alphabetical, -> { order(:name) }
  scope :active,       -> { where(active: true) }
  scope :inactive,     -> { where(active: false) }
  scope :for_category, ->(category) { where(category: category) }
  
  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_numericality_of :units_per_item, only_integer: true, greater_than: 0
  validates_numericality_of :weight, greater_than: 0
  validates_inclusion_of :category, in: CATEGORIES.map{|key, value| value}, message: "is not an option"
  # validates_inclusion_of :category, in: CATEGORIES.to_h.values, message: "is not an option"

  # Other methods
  def current_price
    curr = self.item_prices.current.first
    if curr.nil?
      return nil
    else
      return curr.price
    end
  end

  def price_on_date(date)
    data = self.item_prices.for_date(date).first
    if data.nil?
      return nil
    else
      return data.price
    end
  end

  # Callbacks
  before_destroy do 
    check_if_ever_associated_with_an_order
    if errors.present?
      @destroyable = false
      throw(:abort)
    else
      remove_unshipped_and_unpaid_order_items
    end
  end
  after_destroy :remove_unshipped_and_unpaid_order_items
  after_rollback :convert_to_inactive


  private
  def check_if_ever_associated_with_an_order
    unless self.order_items.shipped.empty?
      errors.add(:base, "This item cannot be deleted because it has been part of a shipped order, but its status has been set to inactive.")
    end
  end

  def convert_to_inactive
    if !@destroyable.nil? && @destroyable == false
      remove_unshipped_and_unpaid_order_items
      make_inactive
    end
    @destroyable = nil
  end

  def remove_unshipped_and_unpaid_order_items
    self.order_items.unshipped.each{|oi| oi.destroy if oi.order.payment_receipt.nil?}
  end


end
