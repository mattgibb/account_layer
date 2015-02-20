presenter = AccountPresenter.new @account, self

json.extract! presenter,
  :id,
  :balance,
  :type,
  :customer_type,
  :customer_name,
  :credit_or_debit
