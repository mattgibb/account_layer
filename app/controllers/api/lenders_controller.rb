module API
  class LendersController < BaseController
    def create
      already_exists =  CustomerProfile.where(lender_params.merge(
        account_group_type: 'AccountGroup::Lender'
      )).exists?

      respond_to do |format|
        if already_exists
          format.json { render json: {message: "Lender already exists."}, status: 200 }
        elsif @lender = AccountGroup::Lender.create_with_profile_and_accounts(lender_params)
          format.json { head 204, location: "#{api_lenders_url}/#{@lender.id}" }
        else
          format.json { render json: {error: "both lender[name] and lender[lendlayer_id] are required"}, status: 422 }
        end
      end
    end

    private
      def lender_params
        # internally, these are CustomerProfile params
        params.require(:lender).permit(:name, :lendlayer_id)
      end
  end
end
