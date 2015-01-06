class BankTransactionsController < ApplicationController
  def index
    @bank_transactions = BankTransaction.includes(:bank_statement).all
  end

  def show
    @bank_transaction = BankTransaction.find params[:id]
  end
end

