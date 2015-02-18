namespace :transactions do
  desc "Clears any data imported from bank statement/report uploads"
  task clear: :environment do
    [BankReconciliation, FirstAssociatesReconciliation].each do |model|
      model.all.includes(:internal_transaction).each do |rec|
        rec.destroy
        rec.internal_transaction.destroy
      end
    end
    BankTransaction.destroy_all
    FirstAssociatesTransaction.destroy_all
    BankStatement.destroy_all
    FirstAssociatesReport.destroy_all
  end
end
