class Account < ActiveRecord::Base
  has_many :credits, class_name: 'Transaction', foreign_key: :credit_id
  has_many :debits,  class_name: 'Transaction', foreign_key: :debit_id

  class << self
    def wells_fargo_cash
      LendlayerAccount::WellsFargoCash.first
    end
  end
end
