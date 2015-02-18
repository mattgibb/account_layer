class FirstAssociatesReportsController < ApplicationController
  def create
    if file = params[:file]
      loader = FirstAssociatesReportLoader.new current_admin, file

      if loader.load
        render text: 'The First Associates report was processed.', status: 201
      else
        render text: 'The First Associates report was already uploaded.', status: 200
      end
    else
      render text: 'You need to include a .xlsx file in the ["file"] field', status: 422
    end
  end
end
