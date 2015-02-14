columns = FirstAssociatesTransaction.column_names

json.attributes columns
json.models do
  json.array!(@first_associates_transactions) do |txn|
    json.is_reconciled txn.reconciled?
    json.extract! txn, *columns
    json.url first_associates_transaction_url(txn, format: :json)
  end
end
