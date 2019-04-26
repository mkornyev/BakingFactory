require 'test_helper'

class CreditCardTypeTest < ActiveSupport::TestCase

  def test_match_method
    # create an object to work with...
    card_type = CreditCardType.new("SMPL", /^(\d{4}[ -]?){4}$/)
    
    # from lab 9
    matching_numbers     = %w[1234567890123456 1234-5678-9012-3456 1234\ 5678\ 9012\ 3456]
    non_matching_numbers = %w[ 1234567890 #1234567890123456 1234|5678|9012|3456]
    
    # matching numbers pass
    matching_numbers.each do |card_number|
      assert card_type.match(card_number)
    end
    
    # non-matching numbers fail
    non_matching_numbers.each do |card_number|
      deny card_type.match(card_number)
      # alternate way of testing...
      assert_nil card_type.match(card_number)
    end
  end
  
  def test_returns_correct_name
    card_type = CreditCardType.new("SMPL", /^(\d{4}[ -]?){4}$/)
    assert_equal "SMPL", card_type.name
  end
    
end