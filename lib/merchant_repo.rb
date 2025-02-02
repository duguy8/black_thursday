require_relative 'csv_generator'

class MerchantRepo
  include CsvGenerator
  attr_reader :merchant_list

  def initialize(csv_data, sales_engine)
    @sales_engine = sales_engine
    make_merchants(csv_data)
  end

  def find_all_items_by_merchant_id(id)
    @sales_engine.find_items_by_id(id)
  end

  def all
    merchant_list
  end

  def find_by_id(id)
    if id.nil?
      nil
    else
      @merchant_list.find do |merchant|
        merchant.id == id
      end
    end
  end

  def find_by_name(name)
    if name.nil?
      nil
    else
       @merchant_list.find do |merchant|
        merchant.name.downcase == name.downcase
      end
    end
  end

  def find_all_by_name(name)
    name = name.downcase
    return [] if name.empty?
      @merchant_list.find_all do |merchant|
      merchant.name.downcase.include?(name)
    end
  end

  def max_merchant_id
    @merchant_list.max_by do |merchant|
      merchant.id
    end.id
  end

  def create(attributes)
    @merchant_list.push(Merchant.new({
                                      id: max_merchant_id + 1,
                                      name: attributes[:name],
                                      created_at: Time.now,
                                      updated_at: Time.now
                                     }, self))
  end

  def update(id, attributes)
    attributes.map do |key, value|
      if key == :name
        find_by_id(id).change_merchant_name(attributes[:name])
      elsif key != :name
        return nil
      end
    end
  end

  def delete(id)
    @merchant_list.reject! do |merchant|
      merchant.id == id
    end
  end
end
