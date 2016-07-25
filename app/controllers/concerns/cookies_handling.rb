module CookiesHandling
  extend ActiveSupport::Concern
  
  private
    def interact_with_cookies
      order_items = OrderItem.compact_order_items(read_from_cookies)
      yield order_items
      write_to_cookies(order_items)
    end

    def push_to_cookies(order_items)
      order_items << OrderItem.new(book_id: params[:book_id], 
                                   quantity: params[:quantity])
    end

    def pop_from_cookies(order_items)
      order_items.each do |item|
        order_items.delete(item) if item.book_id.to_s == params[:book_id]
      end
    end

    def write_to_cookies(items)
      str = ''
      items.each do |item|
        str = [str, item[:book_id], item[:quantity]].join(' ')
      end
      
      cookies[:order_items] = {value: str, expires: 30.days.from_now}
    end

    def read_from_cookies
      order_items = Array.new
      if cookies[:order_items]
        pairs_of_numbers(cookies[:order_items]).each do |item|
          order_items << OrderItem.new(book_id: item[0], quantity: item[1])
        end
      end
      order_items
    end

    def pairs_of_numbers(str)
      str.split(' ').partition.with_index{ |v, index| index.even? }.transpose
    end
end