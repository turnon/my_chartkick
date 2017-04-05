require 'test_helper'

class MyChartkickTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MyChartkick::VERSION
  end

  attr_reader :data

  def setup
    @data = (1..10).to_a
  end

  include MyChartkick

  def test_common_chart
    charts =
      MyChartkick.bundle do |sample|
        %w{line column bar area}.each_with_index do |ch, i|
          i = i + 1
          sample.send "my_#{ch}_chart", data, x: :odd_or_even, id: i.to_s
          sample.send "my_#{ch}_chart", data, x: :odd_or_even, y: :gt9, id: (i * 10).to_s
        end

        sample.send "my_pie_chart", data, x: :odd_or_even, id: '99'
      end

    File.open('/tmp/my_chartkick_test.html', 'w') do |f|
      f.puts charts.sample cdn: true
    end
  end

end
