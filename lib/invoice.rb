class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at

  def initialize(attributes, repository)
    @attributes = attributes
    @repository = repository
    @id = attributes[:id].to_i
    @customer_id = attributes[:customer_id].to_i
    @merchant_id = attributes[:merchant_id].to_i
    @status = attributes[:status].to_sym
    @created_at = Time.parse(attributes[:created_at].to_s)
    @updated_at = Time.parse(attributes[:updated_at].to_s)
  end

  def day_created
    Date.parse(@attributes[:created_at]).strftime("%A")
  end

  def update_time
    @updated_at = Time.now
  end

  def change_status(change)
    @status = change
    update_time
  end

  def merchant
    @repository.find_all_invoices_by_merchant_id(@merchant_id)
  end
end
