class BankStatementsController < ApplicationController
  def create
    if file = params[:bank_statement] && params[:bank_statement][:file]
      loader = BankStatementLoader.new current_admin, file

      if loader.load
        render text: 'The bank statement was processed.', status: 201
      else
        render text: 'The bank statement was already uploaded.', status: 200
      end
    else
      render text: 'You need to include a .qfx file in the ["bank_statement"]["file"] field', status: 422
    end
  end
end
