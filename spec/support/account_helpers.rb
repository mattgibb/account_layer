module AccountHelpers
  def wells_fargo_account
    Account::LendlayerAccount::WellsFargoCash.first
  end
end

