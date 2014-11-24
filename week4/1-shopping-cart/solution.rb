require 'bigdecimal'
require 'bigdecimal/util'
Product = Struct.new(:name, :price, :promotion)

class Inventory
  include Discount

  def initialize
    @products = {}
    @coupons = {}
  end
  	
  def register(name, price_string, promotion = nil)
  	if name.size >= 40 || 
       !(0.1..999.99).include?(price_string.to_d) || @products.include?(name)
  		raise ArgumentError, "Not correct input data"
    end
    if (promotion == nil)
        @products[name] = Product.new(name, price_string, nil)
      else
        @products[name] = Product.new(name, price_string, Discount.build_promotion(promotion))
      end  
  end

  def new_cart
    Cart.new(self)
  end
  
  def price_of(name)
    @products.fetch(name).price
  end
  
  def product_for(name)
    @product[name]
  end
    
  def register_coupon(name, discount)
    @coupons[name] = Discount.build_coupon(discount)
  end

  def coupon_exist?(name)
    @coupons.include?(name)
  end

  def coupon_for(name)
    @coupons[name]
  end
end



class Cart

  def intialize(products)
  	@inventory = products
    @selected = Hash.new(0)
    @coupon_used = false
  end

  def add(name, count = 1)
    raise ArgumentError if count < 1 || count > 99 || !@products.include?(name)
    @selected[name] += count
  end

  def use(coupon_name)
    raise ArgumentError  if !@inventory.coupon_exist?(coupon_name) || coupon_used = true
    @coupon = @inventory.coupon_for(coupon_name)
    @coupon_used = true
  end

  def calcolate_price(product, count)
    [product.price * count, 
    product.promotion.calcolate_discount(product.price, count)]
  end

  def total
  	without_coupon = @selected.map do |name, qty| 
      price = @inventory.product_for(name).price.to_d
      price * qty - @inventory.product_for(name).promotion.get_discount(price, qty)
    end.reduce(:+)
    without_coupon - @coupon(without_coupon).to_f
  end

  def invoice
    output = FormatOutput.header
    @selected.select do |name, count| 
      output += FormatOutput.new(@inventory.product_for(name), count).print
    end

    output += FormatOutput.coupon_line(@coupon, total) + FormatOutput.footer(total)
  end
end

module Discount
  
  class GetOneFree
    def initialize(value)
      @qty_required = value
    end

    def get_discount(price, qty)
      qty / @qty_required * price.to_d
    end

    def print_discount
      promo_text = "(buy #{@qty_required - 1} get 1 free"

    end
  end

  class Package
    def initialize(value)
      @qty_required = value.first[0]
      @percent_discount = value.first[1]
    end

    def get_discount(price, qty)
      qty_valid = qty - qty % @qty_required
      qty_valid * price * (@percent_discount / 100.0)
    end

    def print_discount
      promo_text = "(get #{@percent_discount}% off for every #{@qty_required})"
    end
  end

  class Threshold
    def initialize(value)
      @qty_required = value.first[0]
      @percent_discount = value.first[1]
    end

    def get_discount(price, qty)
      if (qty >= qty_required)
        qty * price * (@percent_discount / 100.0)
      else
        0
      end
    end

    def print_discount
      "(#{@percent_discount}% 
        off of every after the #{ordinal(@qty_required)})"
    end
  end

  class PercentCoupon
    def initialize(name, percent)
      @name = name
      @percent_discount = percent
    end

    def get_discount(bill_price)
      bill_price * (@percent_discount / 100.0)
    end

    def print
      "Coupon #{@name} - #{percent_discount}% off"
    end
  end

  class AmountCoupon
    def initialize(name, amount)
      @name = name
      @discount_amount = amount
    end

    def get_discount(_)
      @discount_amount
    end

    def print
      "Coupon #{@name} - #{discount_amount} off"
    end
  end
  
  def self.build_promotion(promotion)
    value = promotion.first[1]
    case promotion.first[0]
      when :get_one_free then GetOneFree.new(value)
      when :package then Package.new(value)
      when :threshold then Threshold.new(value)
      else nil
    end
  end

  def self.build_coupon(name, discount)
    case discount.first[0]
    when :percent then PercentCoupon.new(name, discount.first[1])
    when :amount then AmountCoupon.new(name, discount.first[1])
    else raise "No such type of coupon", ArgumentError
    end
  end

  def ordinal(n)
    case
    when n % 100 / 10 == 1 then return "#{n}th"
    when n % 10 == 1 then return "#{n}st"
    when n % 10 == 2 then return "#{n}nd"
    when n % 10 == 3 then return "#{n}rd"
    else return "#{n}th"
    end
  end
end

class FormatOutput
  def self.header
    @line = "+" + "-" * 48 + "+" + "-" * 10 + "+\n"
    result = @line + "| Name" + " " * 39 + "qty |" + " " * 4 + "price |\n" + @line
  end

  def self.footer(price)
    @line = "+" + "-" * 48 + "+" + "-" * 10 + "+\n"
    result = @line + "| TOTAL" + " " * 42 + format("|%9.2f |\n", price) + @line
  end

  def self.coupon_line(coupon, price_no_coupon)
    format("|  %-46s |%9.2f |\n", coupon.print, - coupon.get_discount(price_no_coupon)
  end
  def intialize(product, count)
    @product = product
    @count = count
    @price = product.price.to_d
  end

  def print
    if promotion != nil || @promotion.get_discount(@price, @count) != 0
      promo = format("|   %-46s |%9.2f |\n", @promotion.print, - @promotion.get_discount(@price,@count))
    else
      promo = ""
    end
    format("| %-40s%8d |%9.2f |\n", @product.name, @count, @price) + promo
  end

end