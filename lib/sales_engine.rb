class SalesEngine
  include Math

  attr_reader :merchants,
              :items

  def initialize(csv_data)
    make_merchant_repo(csv_data)
    make_item_repo(csv_data)
  end

  def find_merchant_by_merchant_id(id)
    merchants.find_by_id(id)
  end

  def find_average
    (items.item_list.count.to_f / merchants.merchant_list.count.to_f).round(2)
  end

  # def find_variance
    # Calculate Standard Deviation:
    # 1. Need a set of data to work with: items in item list? merchants in merhcant list?
    # 2. Take the difference between each number and the mean(our find average method) and square it
    # 3. Divide the sum by the number of elements minus 1
    #4. Take the square root of this result

    # @exhibits.reduce({}) do |acc, exhibit|
    #   exhibit_patrons = @patrons.find_all do |patron|
    #     patron.interested_in?(exhibit)
    #     # patron.interests.include?(exhibit.name)
    #   end
    #   acc[exhibit] = exhibit_patrons
    #   acc
    # end
    # def standard_deviation
    # one = find_average
    # two = merchant_items.map do |merchant|
    # (one - two) ** 2
    # end.sum
    # Math.sqrt (two / (length - 1)).round(2)
  # end


  #to make this hash
def standard_deviation

  total_count = @merchants.merchant_list.reduce([]) do |acc, merchant|
    # require "pry"; binding.pry
    acc << merchant.item_name.count
    acc
  end

  sum = total_count.sum do |value|
    ((value - find_average)**2)
  end

  # new_sum = ((sum / 475) - 1)

  # summy = (sum / 475) - 1
  #
  # sum = total_count.reduce(0) do |acc, val|
  #   acc += ((val - find_average)**2)
  (Math.sqrt(sum).round(2) * 2)
end



  # std_dev = sqrt( ( (3-4)^2+(4-4)^2+(5-4)^2 ) / 2 )

    # sum = 0

#     total_count.each_value do |value|
#       ((value - find_average) ** 2).sum
#     end


    # @items.item_list.reduce({}) do |acc, item|
    #   merchat_total = @merchants.merchant_list.map do |merchant|
    #     (merchant - find_average)**2
    #   end.sum
    #
    #     (item - find_average)**2
    #





  #   sum => number of items in our item list **2 - number of merchants in our merhcnat list**2
  #
  #
  #   sum = items.item_list.reduce({}) do |acc, i|
  #     acc + (i - mean) ** 2
  #   end
  #   sum / (items.item_list.length - 1).to_f
  # end
  #
  # def standard_deviation
  #   Math.sqrt(find_variance)
  # end

  def find_items_by_id(id)
    items.find_all_by_merchant_id(id)
  end

  def analyst
    SalesAnalyst.new(self)
  end

  def self.from_csv(csv_data)
    SalesEngine.new(csv_data)
  end

  def make_merchant_repo(csv_data)
    @merchants = MerchantRepo.new(csv_data[:merchants], self)
  end

  def make_item_repo(csv_data)
    @items = ItemRepo.new(csv_data[:items], self)
  end
end
