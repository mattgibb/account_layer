class Transaction < ActiveRecord::Base
  belongs_to :credit_account, class_name: 'Account', foreign_key: :credit_id
  belongs_to :debit_account,  class_name: 'Account', foreign_key: :debit_id
  has_one :reconciliation
end
