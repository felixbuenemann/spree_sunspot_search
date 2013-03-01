module Spree
  module Sunspot
    module Filter

      class Filter
        include ActionView::Helpers::NumberHelper
        attr_accessor :search_param
        attr_accessor :search_condition
        attr_accessor :values
        attr_accessor :param_type
        attr_accessor :exclusion

        def initialize
          @values = []
        end

        def values(&blk)
          @values = yield if block_given?
          @values
        end

        def display?
          !values.empty?
        end

        def search_param
          @search_param.to_sym
        end

        def search_condition
          @search_condition
        end

        def exclusion
          @exclusion
        end

        def html_values
          case param_type.to_s
          when "Range"
            values.collect do |range|
              if range.first == 0
                { :display => I18n.t(:range_under, :to => number_to_currency(range.last, :precision => 0)),
                  :value => "#{range.first},#{range.last}" }
              elsif range.last == 0
                { :display => I18n.t(:range_over, :from => number_to_currency(range.first, :precision => 0)),
                  :value => "#{range.first},*" }
              else
                { :display => I18n.t(:range, :from => number_to_currency(range.first, :precision => 0),
                                               :to => number_to_currency(range.last,  :precision => 0)),
                  :value => "#{range.first},#{range.last}" }
              end
            end
          else
            values.collect do |value|
              { :display => value, :value => value }
            end
          end
        end

        def finalize!
          raise ArgumentError.new("search_param is nil") if search_param.nil?
          raise ArgumentError.new("search_condition is nil") if search_condition.nil?
          @param_type ||= values[0].class unless values.empty?
        end
      end
      
    end
  end
end
