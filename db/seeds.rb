[
  ['OriginationFees', 'credit'],
  ['ServicingFees',   'credit'],
  ['WellsFargoCash',  'debit'],
  ['Chargeoffs',      'credit'],
  ['Recoveries',      'credit']
].each do |type, credit_or_debit|
  Account.find_or_create_by type: type, credit_or_debit: credit_or_debit
end
