class AccountGroup < ActiveRecord::Base
  has_many :accounts
end
