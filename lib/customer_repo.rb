require_relative 'csv_generator'

class CustomerRepo
  include CsvGenerator
  attr_reader :all

  def initialize(csv_data, engine)
    create_customer(csv_data)
    @engine = engine
  end

  def find_by_id(id)
    @all.find do |customer|
      customer.id == id
    end
  end

  def find_all_by_first_name(first_name)
    @all.find_all do |name|
      name.first_name.downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    @all.find_all do |name|
      name.last_name.downcase.include?(last_name.downcase)
    end
  end

  def max_customer_id
    @all.max_by do |customer|
      customer.id
    end.id
  end

  def create(attributes)
    @all.push(Customer.new({
                            id: max_customer_id + 1,
                            first_name: attributes[:first_name],
                            last_name: attributes[:last_name],
                            created_at: Time.now,
                            updated_at: Time.now
                           }, self))

  end

  def update(id, attributes)
      attributes.each_key do |key|
        if key == :first_name
          find_by_id(id).change_first_name(attributes[:first_name])
        elsif key == :last_name
          find_by_id(id).change_last_name(attributes[:last_name])
        end
    end

    def delete(id)
      @all.reject! do |customer|
        customer.id == id
      end
    end
  end
end
