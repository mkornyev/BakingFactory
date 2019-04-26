module Contexts
  module CreditCards
    def get_previous_month
      Date.current.month == 1 ? 12 : (Date.current.month - 1)
    end    
    
    def get_year_for_previous_month
      Date.current.month == 1 ? (Date.current.year - 1) : (Date.current.year)
    end
    
    def next_year
      Date.current.year + 1
    end
    
    def last_year
      Date.current.year - 1
    end
    
    def create_valid_cards
      # Create some valid cards (two for each type)
      @visa13        = CreditCard.new(4123456789012, next_year, 12)
      @visa16        = CreditCard.new(4123456789012345, next_year, 12)
      @mc51          = CreditCard.new(5123456789012345, next_year, 12)
      @mc54          = CreditCard.new(5412345678901234, next_year, 12)
      @disc65        = CreditCard.new(6512345678901234, next_year, 12)
      @disc6011      = CreditCard.new(6011123456789012, next_year, 12)
      @dccb300       = CreditCard.new(30012345678901, next_year, 12)
      @dccb303       = CreditCard.new(30312345678901, next_year, 12)
      @amex34        = CreditCard.new(341234567890123, next_year, 12)
      @amex37        = CreditCard.new(371234567890123, next_year, 12)
      @current_month = CreditCard.new(371234567890123, Date.current.year, Date.current.month)
    end
    
    def create_invalid_card_lengths
      # Create some invalid card number lengths (two for each type)
      @bad_visa_digits_minus  = CreditCard.new(412345678901, next_year, 12)
      @bad_visa_digits_middle = CreditCard.new(412345678901234, next_year, 12)
      @bad_visa_digits_plus   = CreditCard.new(41234567890123456, next_year, 12)
      @bad_mc_digits_minus    = CreditCard.new(51234567890123, next_year, 12)
      @bad_mc_digits_plus     = CreditCard.new(54123456789012345, next_year, 12)
      @bad_disc_digits_minus  = CreditCard.new(651234567890123, next_year, 12)
      @bad_disc_digits_plus   = CreditCard.new(60111234567890123, next_year, 12)
      @bad_dccb_digits_minus  = CreditCard.new(3001234567890, next_year, 12)
      @bad_dccb_digits_plus   = CreditCard.new(303123456789012, next_year, 12)
      @bad_amex_digits_minus  = CreditCard.new(34123456789012, next_year, 12)
      @bad_amex_digits_plus   = CreditCard.new(3712345678901234, next_year, 12)
    end
    
    def create_invalid_card_prefixes
      @bad_prefix_visa  = CreditCard.new(1123456789012345, next_year, 12)
      @bad_prefix_mc    = CreditCard.new(5623456789012345, next_year, 12)
      @bad_prefix_disc1 = CreditCard.new(6612345678901234, next_year, 12)
      @bad_prefix_disc2 = CreditCard.new(6001123456789012, next_year, 12)
      @bad_prefix_dccb  = CreditCard.new(30612345678901, next_year, 12)
      @bad_prefix_amex  = CreditCard.new(351234567890123, next_year, 12)
    end
    
    def create_invalid_card_dates
      @last_year  = CreditCard.new(4123456789012345, last_year, 12)
      @last_month = CreditCard.new(4123456789012345, get_year_for_previous_month, get_previous_month)
    end
    
  end
end