columns = BankTransaction.column_names

json.attributes [:account_number] + columns
json.models do
  json.array!(@bank_transactions) do |bank_transaction|
    json.account_number bank_transaction.bank_statement.account_number
    json.extract! bank_transaction, *columns
    json.url bank_transaction_url(bank_transaction, format: :json)
  end
end

