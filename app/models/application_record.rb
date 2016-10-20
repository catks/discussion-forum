class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self

    attr_writer :max_items_for_page
    attr_accessor :pagination_order

    def set_pagination_order(order_method)
      define_singleton_method(:pagination_order){ @pagination_order ||= order_method }
    end

    def set_max_items_for_page(number)
      define_singleton_method(:max_items_for_page){ @max_items_for_page ||= number }
    end

    def max_items_for_page
      @max_items_for_page ||= 10
    end

    def page(num, order: pagination_order)
      if num.nil?
        self.order order
      else
        self.order(order).offset((num.to_i-1)*max_items_for_page).limit(max_items_for_page)
      end
    end

    def pages
      [*1..(self.count / max_items_for_page.to_f).ceil]
    end

    def last_page
      self.page(pages.last)
    end
  end
end
