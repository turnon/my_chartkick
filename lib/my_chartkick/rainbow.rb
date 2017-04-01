module MyChartkick
  module Rainbow

    SCALAR = (0..255)
    SCALAR_DESC = SCALAR.to_a.reverse.slice 1,254

    PALETTE = [SCALAR.map{|c| "rgba(255,#{c},0,1)"},
               SCALAR_DESC.map{|c| "rgba(#{c},255,0,1)"},
               SCALAR.map{|c| "rgba(0,255,#{c},1)"},
               SCALAR_DESC.map{|c| "rgba(0,#{c},255,1)"},
               SCALAR.map{|c| "rgba(#{c},0,255,1)"},
               SCALAR_DESC.map{|c| "rgba(255,0,#{c},1)"},].flatten

    def self.[] n
      picked = rand PALETTE.size
      steps = PALETTE.size / n
      n.times.map do |t|
        picked = picked + steps
        picked = picked - PALETTE.size if picked >= PALETTE.size
        picked
      end.map do |picked|
        RGBA.new PALETTE[picked]
      end
    end

    class RGBA
      def initialize rgba_str
        @rgba = rgba_str
      end

      def to_s
        @rgba
      end

      def alpha f
        self.class.new @rgba.sub(/1\)/, [f, ')'].join)
      end
    end

  end
end
