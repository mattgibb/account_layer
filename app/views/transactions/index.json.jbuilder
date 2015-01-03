json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :credit_id, :debit_id, :amount, :comment, :due_at, :paid_at
  json.url transaction_url(transaction, format: :json)
end
