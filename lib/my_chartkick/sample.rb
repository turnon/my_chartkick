require 'erb'
require 'mutex_m'

module MyChartkick
  class Sample
    include MyChartkick

    MyChartkick.
      instance_methods.
      select do |m|
        m =~ /^my/
      end.
      each do |method_id|
        o_method = "#{method_id}_for_sample"
        alias_method o_method, method_id
        define_method method_id do |data, opt|
          give_id! opt
          chart = send o_method, data, opt
          charts << chart
        end
      end

    attr_reader :charts, :jslib

    def initialize cdn: false
      @jslib = cdn ? MyChartkick::CDN : MyChartkick::Inline
      @charts = []
    end

    def give_id! opt
      opt.merge!({id: ChartId.next}) unless opt[:id]
    end

    def to_s
      ERB.new(Template).result binding
    end

    Template = <<-EOHTML
<!DOCTYPE HTML>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <%= jslib %>
  </head>
  <body>
    <%= charts.join %>
  </body>
</html>
EOHTML

  ChartId = Class.new do
    include Mutex_m
    def initialize
      @id = -1
      super
    end

    def next
      lock
      @id += 1
      unlock
      @id.to_s
    end
  end.new

  end
end
