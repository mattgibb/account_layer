class Admin < ActiveRecord::Base
  has_many :bank_statements
  has_many :reconciliations
end
