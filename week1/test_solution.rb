require 'minitest/autorun'

require_relative 'solution'

class SolutionTest < Minitest::Unit::TestCase
  def test_histogram
    assert histogram('abcdd'), 'a' => 1, 'b' => 1, 'c' => 1, 'd' => 2
  end

  def test_prime
    assert_equal prime?(23), true
    assert_equal prime?(4), false
    assert_equal prime?(1), false
    assert_equal prime?(3), true
  end

  def test_ordinal
    assert_equal ordinal(2), '2nd'
    assert_equal ordinal(3), '3rd'
    assert_equal ordinal(12), '12th'
    assert_equal ordinal(512), '512th'
    assert_equal ordinal(523), '523rd'
  end

  def test_palindrome
    assert_equal palindrome?('Race car'), true
    assert_equal palindrome?('race'), false
  end
end
