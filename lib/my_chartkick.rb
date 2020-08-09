require "my_chartkick/version"
require 'my_chartkick/data_set'
require 'rand_palette'
require 'chartkick'
require 'active_support/core_ext/hash/deep_merge'

module MyChartkick

  DefaultLibOption =
    {library:
     {chart: {zoomType: 'xy'}
    }}

  include Chartkick::Helper

  Chartkick::Helper.instance_methods.each do |helper|
    define_method "my_#{helper}" do |data, opt|
      opt = opt.dup
      data_set = DataSet.create data, opt
      colorize! data_set, opt
      merge_default_opt! opt
      title = opt.delete :title
      chart_block = send helper, data_set, opt
      return chart_block unless title
      title_block(title) + chart_block
    end
  end

  def colorize! data_set, opt
    opt.merge!({colors: RandPalette.random(data_set.count, alpha: 0.8)}) if Array === data_set
  end

  def merge_default_opt! opt
    opt.deep_merge!(DefaultLibOption){|k, old, neo| old}
  end

  def title_block str
    "<div class='my-chartkick-title'>#{str}</div>"
  end

  def self.bundle &blk
    Bundle.new.tap do |bundle|
      blk.call bundle
    end
  end

  CDN = '<script src="http://code.highcharts.com.cn/highcharts/5.0.10/highcharts.js"></script>
         <script src="https://cdn.bootcdn.net/ajax/libs/chartkick/2.2.3/chartkick.min.js"></script>'

  Jslib = File.expand_path '../my_chartkick/js', __FILE__

  Inline = %w{highcharts.js chartkick.min.js}.map do |file|
    src_path = File.join Jslib, file
    src = File.read src_path
    "<script>#{src}</script>"
  end.join

end

require 'my_chartkick/bundle'
