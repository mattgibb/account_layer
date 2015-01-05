json.attributes Transaction.column_names
json.models do
  json.array!(@transactions) do |transaction|
    json.extract! transaction, :id, :name, :balance, :type, :credit_or_debit, :created_at, :updated_at
    json.url transaction_url(transaction, format: :json)
  end
end
