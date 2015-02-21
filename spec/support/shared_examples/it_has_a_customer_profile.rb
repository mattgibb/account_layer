shared_examples "it has a CustomerProfile" do
  def create_customer_profile
    subject.create_profile attributes_for :customer_profile
  end

  def create_cohort_profile
    create :cohort_profile, account_group_id: subject.id, account_group_type: subject.type
  end

  it "can have a CustomerProfile" do
    create_customer_profile
    expect(subject.profile.nil?).to be false
  end

  it "cannot have two CustomerProfiles" do
    create_customer_profile
    expect{create_customer_profile}.to raise_error ActiveRecord::RecordNotUnique
  end

  it "cannot have a CohortProfile" do
    expect{create_cohort_profile}.to raise_error ActiveRecord::StatementInvalid
  end
end
