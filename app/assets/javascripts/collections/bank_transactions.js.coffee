AccountLayer.Collections.BankTransactions = Backbone.Collection.extend
  url: '/bank_transactions'
  model: AccountLayer.Models.BankTransaction
