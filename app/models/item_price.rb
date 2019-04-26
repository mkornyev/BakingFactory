class ItemPrice < ApplicationRecord
  # get modules to help with some functionality
  include AppHelpers::Validations
  include AppHelpers::Deletions

  # Relationships
  belongs_to :item

  # Scopes
  scope :current,       -> { where(end_date:nil) }
  scope :chronological, -> { order(start_date: :desc ) }
  scope :for_date,      ->(date) { where("start_date <= ? AND (end_date >= ? OR end_date IS NULL)", date, date) }
  scope :for_item,      ->(item_id) { where(item_id: item_id) }

  # Validations
  validates_presence_of :item_id
  validates_numericality_of :price, greater_than_or_equal_to: 0
  validate :item_is_active_in_system

  # Callbacks
  before_create do
    set_end_date_of_old_price()
    set_start_date_to_tomorrow()
  end

  before_destroy :cannot_destroy_object

  # Other methods
  private
  def item_is_active_in_system
    is_active_in_system(:item)
  end

  def set_end_date_of_old_price
    previous = ItemPrice.current.for_item(self.item_id).take
    previous.update_attribute(:end_date, Date.current) unless previous.nil?
  end

  def set_start_date_to_tomorrow
    self.start_date = Date.tomorrow
  end
end
