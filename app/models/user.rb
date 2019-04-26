class User < ApplicationRecord
  # get modules to help with some functionality
  include AppHelpers::Deletions
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods

  # Use built-in rails support for password protection
  has_secure_password

  # Relationships
  has_one :customer

  # Scopes
  scope :by_role,      -> { order(:role) }
  scope :alphabetical, -> { order(:username) }
  scope :employees,    -> { where.not(role: 'customer') }

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false}
  validates :role, inclusion: { in: %w[admin baker shipper customer], message: "is not a recognized role in system" }
  validates_presence_of :password, on: :create 
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, on: :create, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long", allow_blank: true

  # For use in authorizing with CanCan
  ROLES = [['Administrator', :admin],['Baker', :baker],['Shipper', :shipper],['Customer',:customer]]

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end

  # Callbacks
  before_destroy :cannot_destroy_object
  
end
