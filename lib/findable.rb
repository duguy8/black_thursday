require 'csv'
require 'time'

module Findable

  def find_by_id(id)
    if id.nil?
      nil
    else
      @item_list.find do |item|
        item.id == id
      end
    end
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

  def find_by_name(name)
    if name.nil?
      nil
    else
       @item_list.find do |item|
        item.name == name
      end
    end
  end
end
