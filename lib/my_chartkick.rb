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

  def self.sample cdn: false, &blk
    Sample.new(cdn: cdn).tap do |smp|
      blk.call smp
    end
  end

  CDN = "<script src='http://cdn.cdnjs.net/highcharts/5.0.0/highcharts.js'></script>
         <script src='http://cdn.cdnjs.net/chartkick/2.1.0/chartkick.min.js'></script>"

  Jslib = File.expand_path '../my_chartkick/js', __FILE__

  Inline = %w{highcharts.js chartkick.min.js}.map do |file|
    src_path = File.join Jslib, file
    src = File.read src_path
    "<script>#{src}</script>"
  end.join

end

require 'my_chartkick/sample'
