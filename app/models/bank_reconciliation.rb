# Model to ensure uniqueness of both transaction and bank_transaction
# Prevents race condition of two transactions being created for one bank_transaction
# Can't move fields onto BankTransaction because might serve as audit trail later
# i.e. might have multiple reconciliations per bank_transaction if mistakes are made
class BankReconciliation < ActiveRecord::Base
  # the method 'transaction' is already used by ActiveRecord
  belongs_to :internal_transaction, class_name: 'Transaction', foreign_key: :transaction_id
  belongs_to :bank_transaction
  belongs_to :admin
end
