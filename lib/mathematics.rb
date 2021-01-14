module Mathematics

  def find_invoice_per_merchant_average
    (@invoices.all.count.to_f / @merchants.merchant_list.count.to_f).round(2)
  end

  def find_average
    (@items.item_list.count.to_f / @merchants.merchant_list.count.to_f).round(2)
  end

  def count_merchants
    total_count = @merchants.merchant_list.reduce([]) do |acc, merchant|
      acc << merchant.item_name.count
      acc
    end
  end

  def standard_deviation
    sum = count_merchants.sum do |value|
      ((value - find_average)**2)
    end
    result = (sum / (@merchants.merchant_list.count.to_f - 1))
    Math.sqrt(result).round(2)
  end

  def count_invoices
    total_invoices = @invoices.all.reduce([]) do |acc, invoice|
      acc << invoice.merchant.count
      acc
    end
  end

  def standard_deviation_for_merchant_invoices
    sum = count_invoices.sum do |value|
      ((value - find_invoice_per_merchant_average)**2)
    end
    result = (sum / ((@invoices.all.count.to_f + @merchants.merchant_list.count.to_f) - 1))
    Math.sqrt(result).floor(2)
  end

  def count_merchants_items
    @merchants.merchant_list.reduce({}) do |acc, merchant|
      acc[merchant] = merchant.item_name.count
      acc
    end
  end

  def find_merchants_with_most_items
    merchant_deviation = (standard_deviation * 2)
    total = []
    count_merchants_items.each do |key, value|
      total << key if value >= merchant_deviation
    end
    total
  end

  def calculate_highest_invoice_deviation
    invoice_deviation = (find_invoice_per_merchant_average +
     (standard_deviation_for_merchant_invoices * 2))
  end

  def find_top_merchants_by_invoice_count
    deviation = calculate_highest_invoice_deviation
    highest_merchants = create_invoices_per_merchant_hash.select do |key, value|
      value >= deviation
    end
    highest_merchants.flat_map do |merchant_id, invoices|
      find_merchant_by_merchant_id(merchant_id)
    end
  end

  def create_invoices_per_merchant_hash
    @invoices.all.reduce({}) do |acc, invoice|
      acc[invoice.merchant_id] = invoice.merchant.count
      acc
    end
  end

  def calculate_invoice_lowest_deviation
    invoice_lowest_deviation = (find_invoice_per_merchant_average -
    (standard_deviation_for_merchant_invoices * 2))
  end

  def find_bottoms_merchants_by_invoice_count
    deviation = calculate_invoice_lowest_deviation
    lowest_merchants = create_invoices_per_merchant_hash.select do |key, value|
      value <= deviation
    end
    lowest_merchants.flat_map do |merchant_id, invoices|
      find_merchant_by_merchant_id(merchant_id)
    end
  end

  def average_item_price_for_merchant(id)
    items = find_items_by_id(id)
    expected = convert_to_list(items).sum(0.0) / convert_to_list(items).size
    BigDecimal(expected, 4)
  end

  def average_average_price_per_merchant
    result = @merchants.merchant_list.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    expected = result.sum(0.0) / result.size
    total_averages = BigDecimal(expected, 5).floor(2)
  end

  def golden_items
    above_average = (2 * average_average_price_per_merchant) -1
    expected = @items.item_list.find_all do |item|
      (item.unit_price_to_dollars / 10) >= above_average
    end
    expected
  end

  def invoice_total(invoice_id)
    successful_transaction = @transactions.find_all_by_invoice_id(invoice_id).find do |transaction|
      transaction.result == :success
    end

    invoice_items = find_all_invoice_items_for_transaction(successful_transaction.invoice_id)
    calculate_invoice_total(invoice_items)
  end

  def calculate_invoice_total(invoice_items)
    total = invoice_items.reduce(0) do |acc, invoice_item|
      acc + (invoice_item.unit_price_to_dollars * invoice_item.quantity)
    end
    BigDecimal(total, 7)
  end
end
