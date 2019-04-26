require 'test_helper'

class CreditCardTest < ActiveSupport::TestCase

  def test_valid_cards
    create_valid_cards
    assert @visa13.valid?
    assert @visa16.valid?
    assert @mc51.valid?
    assert @mc54.valid?
    assert @disc65.valid?
    assert @disc6011.valid?
    assert @dccb300.valid?
    assert @dccb303.valid?
    assert @amex34.valid?
    assert @amex37.valid?
    assert @current_month.valid?
  end

  # Create some valid cards and identify them by their abbreviation
  # def test_card_identification
  #   create_valid_cards
  #   assert_equal("VISA", @visa13.type.name)
  #   assert_equal("VISA", @visa16.type.name)
  #   assert_equal("MC", @mc51.type.name)
  #   assert_equal("MC", @mc54.type.name)
  #   assert_equal("DISC", @disc65.type.name)
  #   assert_equal("DISC", @disc6011.type.name)
  #   assert_equal("DCCB", @dccb300.type.name)
  #   assert_equal("DCCB", @dccb303.type.name)
  #   assert_equal("AMEX", @amex34.type.name)
  #   assert_equal("AMEX", @amex37.type.name)
  # end

  # Create some invalid card lengths and then test
  def test_invalid_card_lenghts
    create_invalid_card_lengths
    deny @bad_visa_digits_minus.valid?
    deny @bad_visa_digits_middle.valid?
    deny @bad_visa_digits_plus.valid?
    deny @bad_mc_digits_minus.valid?
    deny @bad_mc_digits_plus.valid?
    deny @bad_disc_digits_minus.valid?
    deny @bad_disc_digits_plus.valid?
    deny @bad_dccb_digits_minus.valid?
    deny @bad_dccb_digits_plus.valid?
    deny @bad_amex_digits_minus.valid?
    deny @bad_amex_digits_plus.valid?
  end

  # Create some invalid card prefixes and then test
  def test_invalid_card_prefixes
    create_invalid_card_prefixes
    deny @bad_prefix_visa.valid?
    deny @bad_prefix_mc.valid?
    deny @bad_prefix_disc1.valid?
    deny @bad_prefix_disc2.valid?
    deny @bad_prefix_dccb.valid?
    deny @bad_prefix_amex.valid?
  end

  # Create some invalid expiration dates and then test
  def test_invalid_card_dates
    create_invalid_card_dates
    deny @last_year.valid?
    deny @last_month.valid?
  end
    
end
