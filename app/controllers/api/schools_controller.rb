module API
  class SchoolsController < BaseController
    before_action :set_school, only: [:show, :edit, :update, :destroy]

    def index
      @schools = AccountGroup::School.all
    end

    def show
    end

    def new
      @school = AccountGroup::School.new
    end

    def edit
    end

    def create
      already_exists =  CustomerProfile.where(school_params.merge(
        account_group_type: 'AccountGroup::School'
      )).exists?

      respond_to do |format|
        if already_exists
          format.json { render json: {message: "School already exists."}, status: 200 }
        elsif @school = AccountGroup::School.create_with_profile_and_accounts(school_params)
          format.json { head 204, location: "#{api_schools_url}/#{@school.id}" }
        else
          format.json { head status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /api/schools/1
    # PATCH/PUT /api/schools/1.json
    def update
      respond_to do |format|
        if @school.update(school_params)
          format.html { redirect_to @school, notice: 'School was successfully updated.' }
          format.json { render :show, status: :ok, location: @school }
        else
          format.html { render :edit }
          format.json { render json: @school.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @school.destroy
      respond_to do |format|
        format.html { redirect_to schools_url, notice: 'School was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      def set_school
        @school = AccountGroup::School.find(params[:id])
      end

      def school_params
        # actually internally, these are CustomerProfile params
        params.require(:school).permit(:name, :lendlayer_id)
      end
  end
end
