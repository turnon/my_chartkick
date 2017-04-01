require 'test_helper'

class DataSetTest < Minitest::Test

  attr_reader :data

  def setup
    @data = (1..10).to_a
  end

  def test_x
    ds = MyChartkick::DataSet.create data, x: :gt9
    exp = {'less than or equal to 9' => 9, 'greater than 9' => 1}
    assert_equal exp, ds
  end

  def test_x_key_asc
    ds = MyChartkick::DataSet.create data, x: :gt9, asc: :key
    assert_equal 'greater than 9', ds.keys[0]
  end

  def test_x_key_desc
    ds = MyChartkick::DataSet.create data, x: :gt9, desc: :key
    assert_equal 'less than or equal to 9', ds.keys[0]
  end

  def test_x_count_asc
    ds = MyChartkick::DataSet.create data, x: :gt9, asc: :count
    assert_equal 'greater than 9', ds.keys[0]
  end

  def test_x_count_desc
    ds = MyChartkick::DataSet.create data, x: :gt9, desc: :count
    assert_equal 'less than or equal to 9', ds.keys[0]
  end

  def test_x_y
    ds = MyChartkick::DataSet.create data, x: :odd_or_even, y: :gt9
    exp = [{name: 'less than or equal to 9', data: {'odd' => 5, 'even' => 4}},
           {name: 'greater than 9', data: {'odd' => 0, 'even' => 1}}]
    assert_equal exp, ds
  end

  def test_x_y_key_asc
    ds = MyChartkick::DataSet.create data, x: :odd_or_even, y: :gt9, asc: :key
    exp = ['even', 'odd']
    assert_equal exp, ds[0][:data].keys
    assert_equal exp, ds[1][:data].keys
  end

  def test_x_y_key_desc
    ds = MyChartkick::DataSet.create data, x: :odd_or_even, y: :gt9, desc: :key
    exp = ['odd', 'even']
    assert_equal exp, ds[0][:data].keys
    assert_equal exp, ds[1][:data].keys
  end
end
