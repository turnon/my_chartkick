require "my_chartkick/version"
require 'my_chartkick/data_set'
require 'rand_palette'
require 'chartkick'

module MyChartkick

  Chartkick::Helper.instance_methods.each do |method|
    define_method "my_#{method}" do |data, opt|
      opt = opt.dup
      data_set = DataSet.create data, opt
      opt.merge!({colors: RandPalette.random(data_set.count, alpha: 0.8)}) if Array === data_set
      send method, data_set, opt
    end
  end

  include Chartkick::Helper
end
