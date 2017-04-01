require "my_chartkick/version"
require 'my_chartkick/data_set'
require 'my_chartkick/rainbow'
require 'chartkick'

module MyChartkick

  Chartkick::Helper.instance_methods.each do |method|
    define_method "my_#{method}" do |data, opt|
      opt = opt.dup
      data_set = DataSet.create data, opt
      opt.merge!({colors: Rainbow[data_set.count]}) if Array === data_set
      send method, data_set, opt
    end
  end

  include Chartkick::Helper
end
