FactoryGirl.define do
  factory :bank_statement do
    admin
    contents "<some><qfx-xml></qfx-xml></some>"
  end

end
