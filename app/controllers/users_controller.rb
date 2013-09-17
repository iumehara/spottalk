class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.lat.present? && correct_location?(@user)    
        if @user.save
          sign_in @user
          @location = @user.location
          format.html { redirect_to @location }
          flash[:success] = "Welcome to #{@user.location.name}! Join the party!"
        else
          format.html { redirect_to locations_path }
        end
      elsif @user.lat.nil?
        flash[:alert] = "We couldn't get your location info!"
        format.html { render 'public/no_location.html.erb'} 
      else
        format.html { redirect_to locations_path }
        flash[:alert] = "You're not at the venue! Try checking in after you get here!"
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :location_id, :lat, :long)
    end

    def correct_location?(user)
      (user.lat > user.location.lat_min)  &&
      (user.lat < user.location.lat_max)  &&
      (user.long > user.location.long_min) &&
      (user.long < user.location.long_max)
    end


end
