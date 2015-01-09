class CustomerProfile < ActiveRecord::Base
  belongs_to :customer,
             polymorphic: true,
             foreign_key: :account_group_id,
             foreign_type: :account_group_type

end
