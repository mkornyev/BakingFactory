class Customer < ApplicationRecord
  # get modules to help with some functionality
  include AppHelpers::Validations
  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # Relationships
  has_many :orders
  has_many :addresses
  belongs_to :user

  # Allow user to be nested within customer
  accepts_nested_attributes_for :user, reject_if: ->(user) { user[:username].blank? }, allow_destroy: true

  # Scopes
  scope :alphabetical,  -> { order(:last_name).order(:first_name) }

  # Validations
  validates_presence_of :last_name, :first_name
  validates_format_of :phone, with: /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format"


  # Callbacks
  before_save :reformat_phone
  before_update :deactive_user_if_customer_inactive
  before_destroy :cannot_destroy_object

  # Other methods
  def name
    "#{last_name}, #{first_name}"
  end

  def proper_name
    "#{first_name} #{last_name}"
  end

  def billing_address
    self.addresses.active.billing.first
  end

  # Private methods
  private
  def reformat_phone
    self.phone = self.phone.to_s.gsub(/[^0-9]/,"")
  end

  def deactive_user_if_customer_inactive
    if !self.active && !self.user.nil?
      self.user.active = false
      self.user.save
    end
  end
end
