# No need for a Rails model, just bung the compound types in the db
[
  ['Origination Fees', 'ControlAccount', 'credit'],
  ['Servicing Fees',   'ControlAccount', 'credit'],
  ['Chargeoffs',       'ControlAccount', 'credit'],
  ['Recoveries',       'ControlAccount', 'credit']
].each do |name, type, credit_or_debit|
  Account.find_or_create_by name: name, type: type, credit_or_debit: credit_or_debit
end

