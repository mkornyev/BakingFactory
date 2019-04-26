# a general class that I will use below in the CreditCard class
# purpose of this class is to create types of credit cards, like 
# VISA, MC, AMEX, etc., that we can use the proposed card matches
# one of these credit card types...

class CreditCardType
  attr_reader :name, :pattern

  def initialize(name, pattern)
    @name, @pattern = name, pattern
  end

  def match(number)
    number.to_s.match(pattern)
  end
end