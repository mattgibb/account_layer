class CustomerAccount < Account
  # enforced by db constraints, but here to autopopulate new records
  default_scope { where belongs_to_customer: true }

  belongs_to :customer
end
