# Model to ensure uniqueness of both transaction and bank_transaction
# Prevents race condition of two transactions being created for one bank_transaction
class Reconciliation < ActiveRecord::Base
  # the method 'transaction' is already used by ActiveRecord
  belongs_to :internal_transaction, class_name: 'Transaction', foreign_key: :transaction_id
  belongs_to :bank_transaction
  belongs_to :admin
end
