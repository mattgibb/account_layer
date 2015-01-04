json.attributes Transaction.column_names
json.models do
  json.array!(@transactions) do |transaction|
    json.extract! transaction, :id, :credit_id, :debit_id, :amount, :comment, :due_at, :paid_at, :created_at, :updated_at
    json.url transaction_url(transaction, format: :json)
  end
end
