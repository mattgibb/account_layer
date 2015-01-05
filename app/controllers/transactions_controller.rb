class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  def index
    @transactions = Transaction.all
  end

  def create
    @transaction = Transaction.new(transaction_params)

    byebug
    if @transaction.save
      render :show, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      render :show, status: :ok, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    head :no_content
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params[:transaction].permit :amount, :due_at, :paid_at, :credit_id, :debit_id, :comment
    end
end
