columns = AccountPresenter.column_names
json.attributes columns

json.models do
  json.array!(@accounts) do |account|
    presenter = AccountPresenter.new account, self
    json.extract! presenter, *columns
    json.url account_url(presenter, format: :json)
  end
end
