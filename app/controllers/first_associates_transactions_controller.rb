class FirstAssociatesTransactionsController < ApplicationController
  before_action :set_first_associates_transaction, only: [:show, :reconciliation]

  def index
    @bank_transactions = FirstAssociatesTransaction.all
  end

  def show
  end

  def reconciliation
    if account_exists?
      @first_associates_transaction.reconcile! params[:account_id], current_admin
      render json: {message: "Account is reconciled"}, status: 201
    else
      render json: {error: "The account does not exist"}, status: 404
    end
  end

  private

    def set_first_associates_transaction
      @first_associates_transaction = FirstAssociatesTransaction.find(params[:id])
    end

    def account_exists?
      Account.where(id: params[:account_id]).exists?
    end
end
