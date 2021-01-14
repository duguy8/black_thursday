require_relative 'csv_generator'

class InvoiceItemRepo
  include CsvGenerator
  attr_reader :all

  def initialize(csv_data, engine)
    create_invoice_items(csv_data)
    @engine = engine
  end

  def find_by_id(id)
    @all.find do |invoice_item|
      invoice_item.id == id
    end
  end

  def find_all_by_item_id(id)
    @all.find_all do |invoice_item|
      invoice_item.item_id == id
    end
  end

  def find_all_by_invoice_id(id)
    @all.find_all do |invoice|
      invoice.invoice_id == id
    end
  end

  def max_invoice_item_id
    @all.max_by do |invoice|
      invoice.id
    end.id
  end

  def create(attributes)
    @all.push(InvoiceItem.new({
                                id: max_invoice_item_id + 1,
                                item_id:  attributes[:item_id],
                                invoice_id:  attributes[:invoice_id],
                                quantity: attributes[:quantity],
                                unit_price:  attributes[:unit_price],
                                created_at:  Time.now,
                                updated_at:  Time.now
                              }))
  end

  def update(id, attributes)
    attributes.map do |key, value|
      if key == :quantity
        find_by_id(id).update_quantity(attributes[:quantity])
      elsif key == :unit_price
        find_by_id(id).update_unit_price(attributes[:unit_price])
      end
    end
  end

  def delete(id)
      @all.reject! do |invoice_item|
        invoice_item.id == id
      end
    end
end
