$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'my_chartkick'

require 'minitest/autorun'

class Fixnum
  def odd_or_even
    odd? ? 'odd' : 'even'
  end

  def gt9
    self > 9 ? 'greater than 9' : 'less than or equal to 9'
  end
end
