require_relative 'csv_generator'

class InvoiceRepo
  include CsvGenerator
  attr_reader :all

  def initialize(csv_data, engine)
    create_invoices(csv_data)
    @engine = engine
  end

  def delete(id)
    @all.reject! do |invoice|
      invoice.id == id
    end
  end

  def find_all_invoices_by_merchant_id(merchant_id)
    @engine.find_invoices_by_merchant(merchant_id)
  end


  def update(id, attributes)
    attributes.map do |key, value|
      if key == :status
        find_by_id(id).change_status(attributes[:status])
      elsif key != :status
        return nil
      end
    end
  end

  def max_invoice_id
    @all.max_by do |invoice|
      invoice.id
    end.id
  end

  def create(attributes)
    @all.push(Invoice.new({
                            id: max_invoice_id + 1,
                            customer_id: attributes[:customer_id],
                            merchant_id: attributes[:merchant_id],
                            status: attributes[:status],
                            created_at: Time.now,
                            updated_at: Time.now
                          }, self))
  end

  def find_all_by_status(status)
    @all.find_all do |invoice|
      invoice.status == status
    end
  end

  def find_all_by_merchant_id(id)
    @all.find_all do |invoice|
      invoice.merchant_id == id
    end
  end

  def find_all_by_customer_id(id)
    @all.find_all do |invoice|
      invoice.customer_id == id
    end
  end

  def find_by_id(id)
    @all.find do |invoice|
      invoice.id == id
    end
  end
end
