class FirstAssociatesReconciliation < ActiveRecord::Base
  # the method 'transaction' is already used by ActiveRecord
  belongs_to :internal_transaction, class_name: 'Transaction', foreign_key: :transaction_id
  belongs_to :first_associates_transaction
  belongs_to :admin
end
