require 'csv'
require 'time'

module CsvGenerator

  def create_customer(csv_data)
    customer = CSV.open(csv_data, headers: true,
    header_converters: :symbol)

    @all = customer.map do |customer|
      Customer.new(customer, self)
    end
  end

  def create_transactions(csv_data)
    transaction = CSV.open(csv_data, headers: true,
    header_converters: :symbol)

    @all = transaction.map do |transaction|
      Transaction.new(transaction, self)
    end
  end

  def create_invoices(csv_data)
    invoices = CSV.open(csv_data, headers: true,
    header_converters: :symbol)

    @all = invoices.map do |invoice|
      Invoice.new(invoice, self)
    end
  end

  def create_invoice_items(csv_data)
    invoice_items = CSV.open(csv_data, headers: true,
    header_converters: :symbol)

    @all = invoice_items.map do |invoice_item|
      InvoiceItem.new(invoice_item)
    end
  end

  def make_items(csv_data)
    items = CSV.open(csv_data, headers: true,
    header_converters: :symbol)

    @item_list = items.map do |item|
      Item.new(item, self)
    end
  end

  def make_merchants(csv_data)
    merchants = CSV.open(csv_data, headers: true,
    header_converters: :symbol)

    @merchant_list = merchants.map do |merchant|
      Merchant.new(merchant, self)
    end
  end
end
