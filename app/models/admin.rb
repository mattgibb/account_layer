class Admin < ActiveRecord::Base
  has_many :bank_statements
  has_many :first_associates_reports
  has_many :bank_reconciliations
end
