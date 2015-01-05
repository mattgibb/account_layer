class Admin < ActiveRecord::Base
  has_many :bank_statements
end
