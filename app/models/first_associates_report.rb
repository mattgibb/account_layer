class FirstAssociatesReport < ActiveRecord::Base
  belongs_to :admin
  has_many :first_associates_transactions
end
