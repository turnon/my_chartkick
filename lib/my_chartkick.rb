require "my_chartkick/version"
require 'my_chartkick/data_set'
require 'chartkick'

module MyChartkick

  Chartkick::Helper.instance_methods.each do |method|
    define_method "my_#{method}" do |data, opt|
      data_set = DataSet.create data, opt
      send method, data_set, opt
    end
  end

  include Chartkick::Helper
end
