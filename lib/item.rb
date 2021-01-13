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

  def initialize(attributes, repository)
    @repository = repository
    @attributes = attributes
    @id = attributes[:id].to_i
    @name = attributes[:name]
    @description = attributes[:description]
    @unit_price = BigDecimal(attributes[:unit_price]) / 100
    @created_at = Time.parse(attributes[:created_at].to_s)
    @updated_at = Time.parse(attributes[:created_at].to_s)
    @merchant_id = attributes[:merchant_id]
  end

  def update_time
    @updated_at = Time.now
  end

  def update_unit_price(price)
    @unit_price = price
    update_time
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end

  def find_merchant
    @repository.find_merchant_by_id(@merchant_id)
  end
end
