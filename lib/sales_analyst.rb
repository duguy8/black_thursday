require_relative 'mathematics'
require_relative './sales_engine'
require_relative './transaction_repo'
require_relative './transaction'
require_relative './invoice_repo'
require_relative './invoice'
require_relative './customer_repo'
require_relative './customer'
require_relative './invoice_item_repo'
require_relative './invoice_item'
require_relative './merchant_repo'
require_relative './item_repo'
require_relative './merchant'
require_relative './item'


class SalesAnalyst < SalesEngine
  include Mathematics
  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(merchants, items, invoices, invoice_items, transactions, customers)
    @merchants = merchants
    @items = items
    @invoices = invoices
    @invoice_items = invoice_items
    @transactions = transactions
    @customers = customers
  end

  def invoice_paid_in_full?(invoice_id)
    all_transactions = @transactions.find_all_by_invoice_id(invoice_id)

    all_transactions.any? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_status(status)
    find_invoice_status_percentage(status)
  end

  def top_days_by_invoice_count
    top_day_of_the_week
  end

  def bottom_merchants_by_invoice_count
    find_bottom_merchants
  end

  def top_merchants_by_invoice_count
    find_top_merchants
  end

  def average_invoices_per_merchant_standard_deviation
    find_invoice_standard_deviation
  end

  def average_invoices_per_merchant
    find_invoice_averages
  end

  def average_items_per_merchant
    find_average
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation
  end

  def merchants_with_high_item_count
    find_merchants_with_most_items
  end

  def convert_to_list(items)
    found = items.each_with_object([]) do |item, array|
      array << item.unit_price.to_f
      array
    end
    found
  end
end
