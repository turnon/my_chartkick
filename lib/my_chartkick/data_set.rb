require 'set'

module MyChartkick

  class DataSet
    class << self
      def create data, opt={}
        raise ArgumentError, ':x requried, :y optional' unless opt[:x]
        ds = opt[:y] ? XY.new(data, opt[:x], opt[:y]) : X.new(data, opt[:x])
        ds.supply_keys! opt[:keys] if opt[:keys]
        ds.sort! opt if opt[:asc] or opt[:desc]
        ds.limit! limit_conditions(opt) if opt[:first] or opt[:last]
        ds.data_set
      end

      def limit_conditions opt
        opt.select{|k ,v| [:first, :last].include? k}
      end
    end

    attr_reader :data_set

    def count key_objs
      Hash[key_objs.map{|key, objs| [key, objs.count]}]
    end

    def sort hash, opt={}
      by = if opt[:asc] == :key
             -> kv1, kv2 { kv1[0] <=> kv2[0] }
           elsif opt[:asc] == :count
             -> kv1, kv2 { kv1[1] <=> kv2[1] }
           elsif opt[:desc] == :key
             -> kv1, kv2 { kv2[0] <=> kv1[0] }
           elsif opt[:desc] == :count
             -> kv1, kv2 { kv2[1] <=> kv1[1] }
           end
      Hash[hash.sort &by]
    end

    def limit_hash hash, limit, n
      Hash[hash.to_a.send(limit, n)]
    end
  end

  class X < DataSet
    def initialize data, x_key
      x = data.group_by &x_key
      @data_set = count x
    end

    def supply_keys! keys
      keys.each do |k|
        data_set[k] = 0 unless @data_set[k]
      end
    end

    def sort! opt
      @data_set = sort data_set, opt
    end

    def limit! opt
      opt.each do |limit, n|
        @data_set = limit_hash data_set, limit, n
      end
    end
  end

  class XY < DataSet
    def initialize data, x_key, y_key
      all_x = Set.new

      y = data.group_by &y_key

      @data_set =
        y.map do |key, objs|
          x = objs.group_by &x_key
          x.keys.each{|x_k| all_x << x_k}
          [key, x]
        end.map do |key, objs|
          all_x.each do |x|
            objs[x] = [] unless objs[x]
          end
          {name: key, data: count(objs)}
        end
    end

    def supply_keys! keys
      data_set.each do |subset|
        keys.each do |k|
          subset[:data][k] = 0 unless subset[:data][k]
        end
      end
    end

    def sort! opt
      raise ArgumentError, 'chart with :y can not be sorted by :count' if [opt[:asc], opt[:desc]].include? :count
      data_set.each do |subset|
        subset[:data] = sort subset[:data], opt
      end
    end

    def limit! opt
      data_set.each do |subset|
        opt.each do |limit, n|
          subset[:data] = limit_hash subset[:data], limit, n
        end
      end
    end
  end
end
