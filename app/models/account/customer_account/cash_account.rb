class Account
  class CustomerAccount::CashAccount < CustomerAccount
    default_scope { where credit_or_debit: 'credit' }
  end
end
