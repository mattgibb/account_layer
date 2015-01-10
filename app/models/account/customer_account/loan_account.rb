class Account
  class CustomerAccount::LoanAccount < CustomerAccount
    default_scope { where credit_or_debit: 'debit' }
  end
end


