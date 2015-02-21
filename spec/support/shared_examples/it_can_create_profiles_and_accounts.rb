shared_examples "it can create profiles and accounts" do
  let(:params) { {name: 'A name', lendlayer_id: 123} }
  subject { described_class.create_with_profile_and_accounts params }

  it "creates an AccountGroup, a profile and cash account" do
    expect(subject).to be_persisted
    expect(subject.cash_account).to be_persisted
    expect(CustomerProfile.where(params.merge(
        account_group_id: subject.id,
        account_group_type: described_class
    ))).to exist
  end

  context 'with invalid params' do
    let(:params) { {} }

    it { is_expected.to be_nil }

    it "doesn't create anything" do
      expect{subject}.not_to change {described_class.count}
      expect{subject}.not_to change {CustomerProfile.count}
      expect{subject}.not_to change {Account.count}
    end
  end
end
