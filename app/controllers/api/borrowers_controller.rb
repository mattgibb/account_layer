module API
  class BorrowersController < BaseController
    def create
      already_exists =  CustomerProfile.where(borrower_params.merge(
        account_group_type: 'AccountGroup::Borrower'
      )).exists?

      respond_to do |format|
        if already_exists
          format.json { render json: {message: "Borrower already exists."}, status: 200 }
        elsif @borrower = AccountGroup::Borrower.create_with_profile_and_accounts(borrower_params)
          format.json { head 204, location: "#{api_borrowers_url}/#{@borrower.id}" }
        else
          format.json { render json: {error: "both borrower[name] and borrower[lendlayer_id] are required"}, status: 422 }
        end
      end
    end

    private
      def borrower_params
        # internally, these are CustomerProfile params
        params.require(:borrower).permit(:name, :lendlayer_id)
      end
  end
end
