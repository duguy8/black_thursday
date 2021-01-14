require_relative 'mathematics'
require_relative './sales_engine'
require_relative './merchant_repo'
require_relative './item_repo'
require_relative './merchant'
require_relative './item'
require_relative './transaction'
require_relative './transaction_repo'
require_relative './customer'
require_relative './customer_repo'
require_relative './invoice_item'
require_relative './invoice_item_repo'
require_relative './invoice'
require_relative './invoice_repo'

class SalesEngine
  include Math
  include Mathematics

  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items,
              :transactions,
              :customers


  def initialize(csv_data)
    routes1(csv_data)
    routes2(csv_data)
    routes3(csv_data)
  end

  def routes1(csv_data)
    csv_data.each_key do |key|
      if key == :items
        @items = ItemRepo.new(csv_data[:items], self)
      elsif key == :merchants
        @merchants = MerchantRepo.new(csv_data[:merchants], self)
      end
    end
  end

  def routes2(csv_data)
    csv_data.each_key do |key|
      if key == :invoices
        @invoices = InvoiceRepo.new(csv_data[:invoices], self)
      elsif key == :invoice_items
        @invoice_items = InvoiceItemRepo.new(csv_data[:invoice_items], self)
      end
    end
  end

  def routes3(csv_data)
    csv_data.each_key do |key|
      if key == :transactions
        @transactions = TransactionRepo.new(csv_data[:transactions], self)
      elsif key == :customers
        @customers = CustomerRepo.new(csv_data[:customers], self)
      end
    end
  end


  def find_all_invoice_items_for_transaction(invoice_id)
    @invoice_items.find_all_by_invoice_id(invoice_id)
  end

  def find_status_of_invoice_percentage
    find_invoice_status_percentage(status)
  end

  def create_invoices_by_day_hash
    @invoices.all.reduce(Hash.new(0)) do |acc, invoice|
      acc ||= nil
      acc[invoice.day_created] += 1
      acc
    end
  end

  def top_day_of_the_week
    create_invoices_by_day_hash.select do |day, invoices_count|
      invoices_count == create_invoices_by_day_hash.values.max
    end.keys
  end

  def find_bottom_merchants
    find_bottoms_merchants_by_invoice_count
  end

  def find_top_merchants
    find_top_merchants_by_invoice_count
  end

  def find_invoice_standard_deviation
    standard_deviation_for_merchant_invoices
  end

  def find_invoice_averages
    find_invoice_per_merchant_average
  end

  def find_invoices_by_merchant(merchant_id)
    @invoices.find_all_by_merchant_id(merchant_id)
  end

  def find_merchant_by_merchant_id(id)
    @merchants.find_by_id(id)
  end

  def find_items_by_id(id)
    @items.find_all_by_merchant_id(id)
  end

  def analyst
    SalesAnalyst.new(@merchants, @items, @invoices, @invoice_items, @transactions, @customers)
  end

  def self.from_csv(csv_data)
    SalesEngine.new(csv_data)
  end
end
