require 'erb'

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
          chart = send o_method, data, opt
          charts << chart
        end
      end

    attr_reader :charts, :jslib

    def initialize cdn: false
      @jslib = cdn ? MyChartkick::CDN : MyChartkick::Inline
      @charts = []
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

  end
end
