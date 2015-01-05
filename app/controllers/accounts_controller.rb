class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  def index
    @accounts = Account.all
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      render :show, status: :created, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def update
    if @account.update(account_params)
      render :show, status: :ok, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
    head :no_content
  end

  private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params[:account].permit :credit_or_debit
    end
end
