json.attributes Account.column_names
json.models do
  json.array!(@accounts) do |account|
    json.extract! account, :id, :name, :balance, :type, :credit_or_debit, :created_at, :updated_at
    json.url account_url(account, format: :json)
  end
end
