class Order < ApplicationRecord
  # get module to help with some functionality
  include AppHelpers::Validations
  include AppHelpers::Deletions
  include AppHelpers::Shipping
  require 'base64'

  # Relationships
  belongs_to :customer
  belongs_to :address
  has_many :order_items
  has_many :items, through: :order_items

  # Virtual attributes (non-saved)
  attr_accessor :credit_card_number
  attr_accessor :expiration_year
  attr_accessor :expiration_month

  # Scopes
  scope :chronological, -> { order(date: :desc) }
  scope :paid,          -> { where.not(payment_receipt: nil) }
  scope :for_customer,  ->(customer_id) { where(customer_id: customer_id) }

  # Class methods
  def self.not_shipped
    # joins(:order_items).where("order_items.shipped_on IS NULL").to_a.uniq
    joins(:order_items).where("order_items.shipped_on IS NULL").distinct

  end

  # Other methods
  def unshipped_items
    self.order_items.unshipped
  end

  # Validations
  # validates_date :date
  # validates_numericality_of :grand_total, greater_than_or_equal_to: 0, allow_blank: true
  validates_presence_of :customer_id, :address_id
  validate :customer_is_active_in_system
  validate :address_is_active_in_system
  validate :credit_card_number_is_valid
  validate :expiration_date_is_valid

  # Other methods
  def is_editable?
    !self.order_items.unshipped.empty?
  end

  def pay
    return false unless self.payment_receipt.nil?
    generate_payment_receipt
    self.save!
    self.payment_receipt
  end

  def total_weight
    weight = self.order_items.inject(0){|sum, oi| sum += oi.item.weight * oi.quantity}
  end

  def shipping_costs
    calculate_shipping_costs(self.total_weight, base=2.00)
  end

  def credit_card_type
    credit_card.type.nil? ? "N/A" : credit_card.type.name
  end

  # Callbacks
  before_destroy do
    check_if_any_order_items_shipped
    if errors.present?
      @destroyable = false
      throw(:abort)
    end
    remove_order_items
  end

  private
  def customer_is_active_in_system
    is_active_in_system(:customer)
  end

  def address_is_active_in_system
    is_active_in_system(:address)
  end

  def generate_payment_receipt
    self.payment_receipt = Base64.encode64("order: #{self.id}; amount_paid: #{self.grand_total}; received: #{self.date}; card: #{self.credit_card_type} ****#{self.credit_card_number[-4..-1]}; billing zip: #{self.customer.billing_address.zip}")
  end

  def credit_card
    CreditCard.new(self.credit_card_number, self.expiration_year, self.expiration_month)
  end

  def credit_card_number_is_valid
    return false if self.expiration_year.nil? || self.expiration_month.nil?
    if self.credit_card_number.nil? || credit_card.type.nil?
      errors.add(:credit_card_number, "is not valid")
      return false
    end
    true
  end

  def expiration_date_is_valid
    return false if self.credit_card_number.nil? 
    if self.expiration_year.nil? || self.expiration_month.nil? || credit_card.expired?
      errors.add(:expiration_year, "is expired")
      return false
    end
    true
  end

  def check_if_any_order_items_shipped
    unless self.order_items.shipped.empty?
      errors.add(:base, "This order has already been partially shipped and therefore cannot be deleted.")
    end
  end

  def remove_order_items
    self.order_items.each{ |oi| oi.destroy }
  end
end
