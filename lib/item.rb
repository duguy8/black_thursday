require 'bigdecimal'

class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id,
              :unit_price_to_dollars

  def initialize(input, repository)
    @repository = repository
    @input = input
    @id = input[:id].to_i
    @name = input[:name]
    @description = input[:description]
    @unit_price = BigDecimal(input[:unit_price]) / 100
    @created_at = input[:created_at]
    @updated_at = Time.now
    @merchant_id = input[:merchant_id]
  end

  def update
    t1 = #when we created this
    t2 = #when we updated thisTime.now
    t3 = t1 - t2
    original_time = Time.now
    # if @updated_at  >= original_time
    if t1 < t2
      t3
    else
      @updated_at
    end

    # original_time = Time.now
    # new_time = #change Time.now
    # original_time == new_time
  end

  def update_unit_price(price)
    @unit_price = price
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def find_merchant
    @repository.find_merchant_by_id(@merchant_id)
  end
end
