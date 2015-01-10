class BankTransactionsController < ApplicationController
  before_action :set_bank_transaction, only: [:show, :reconciliation]

  def index
    @bank_transactions = BankTransaction.includes(:bank_statement).all
  end

  def show
  end

  def reconciliation
    if account_exists?
      @bank_transaction.reconcile! params[:account_id], current_admin
      render json: {message: "Account is reconciled"}, status: 201
    else
      render json: {error: "The account does not exist"}, status: 404
    end
  end

  private

    def set_bank_transaction
      @bank_transaction = BankTransaction.find(params[:id])
    end

    def account_exists?
      Account.where(id: params[:account_id]).exists?
    end
end

