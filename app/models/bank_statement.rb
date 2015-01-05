class BankStatement < ActiveRecord::Base
  belongs_to :admin
  has_many :bank_transactions
end
