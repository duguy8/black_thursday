require_relative 'csv_generator'

class ItemRepo
  include CsvGenerator
  attr_reader :item_list

  def initialize(csv_data, sales_engine)
    @sales_engine = sales_engine
    make_items(csv_data)
  end

  def find_merchant_by_id(merchant_id)
    @sales_engine.find_merchant_by_merchant_id(merchant_id)
  end

  def all
    item_list
  end

  def find_by_id(id)
    if id.nil?
      nil
    else
      @item_list.find do |item|
      item.id == id
      end
    end
  end

  def find_by_name(name)
    if name.nil?
      nil
    else
       @item_list.find do |item|
        item.name == name
      end
    end
  end

  def find_all_with_description(description)
    description = description.downcase

    return [] if description.nil?

    @item_list.find_all do |item|
      item.description.downcase.include?(description)
    end
  end

  def find_all_by_price(price)
    return [] if price.nil?

    @item_list.find_all do |item|
      item.unit_price_to_dollars == price
    end
  end

  def find_all_by_price_in_range(range)
    return [] if range.nil?
    range_array = range.to_s
    @item_list.find_all do |item|
      (item.unit_price_to_dollars >= range_array.split.first.to_f) &&
      (item.unit_price_to_dollars <= range_array.split("..").last.to_f)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    return [] if merchant_id.nil?

    @item_list.find_all do |item|
      item.merchant_id.to_i == merchant_id
    end
  end

  def max_item_id
    item_list.max_by do |item|
      item.id
    end.id
  end

  def create(attributes)
    item_list.push(Item.new({
                                      id: max_item_id.to_i + 1,
                                      name: attributes[:name],
                                      description: attributes[:description],
                                      unit_price: attributes[:unit_price],
                                      merchant_id: attributes[:merchant_id],
                                      created_at: Time.now,
                                      updated_at: Time.now
                                    }, self))
  end

  def delete(id)
    @item_list.reject! do |item|
      item.id == id
    end
  end

  def update(id, attributes)
      attributes.each_key do |key|
        if key == :unit_price
          find_by_id(id).update_unit_price(attributes[:unit_price])
        elsif key != :unit_price
          return nil
      end
    end
  end
end
