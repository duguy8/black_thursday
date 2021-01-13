class Transaction
  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at

  def initialize(attributes, repository)
    @repository = repository
    @id = attributes[:id].to_i
    @invoice_id = attributes[:invoice_id].to_i
    @credit_card_number = attributes[:credit_card_number]
    @credit_card_expiration_date = attributes[:credit_card_expiration_date]
    @result = attributes[:result].to_sym
    @created_at = Time.parse(attributes[:created_at].to_s)
    @updated_at = Time.parse(attributes[:updated_at].to_s)
  end

  def change_result(change)
    @result = change
    update_time
  end

  def update_time
    @updated_at = Time.now
  end

  def find_all_invoice_items_by_invoice_id(invoice_id)
    @repository.relay_transaction_information(@invoice_id)
  end
end
