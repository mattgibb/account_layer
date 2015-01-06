json.account_number @bank_transaction.bank_statement.account_number
json.extract! @bank_transaction, *BankTransaction.column_names
