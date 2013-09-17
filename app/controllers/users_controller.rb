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
      if correct_location?(@user)    
        if @user.save
          sign_in @user
          @location = @user.location
          format.html { redirect_to @location, notice: "You have checked in to #{@location.name} as #{@user.name}" }
          format.json { render action: 'show', status: :created, location: @user }
        else
          format.html { redirect_to locations_path }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to locations_path }
        format.json { render json: @user.errors, notice: "You don't seem to be at this location!" }
         puts "#{@user.lat > @user.location.lat_min}"
         puts "#{@user.lat < @user.location.lat_max}"
         puts "#{@user.long > @user.location.lat_min}"
         puts "#{@user.long > @user.location.lat_max}"
         puts "wrong loctation!"
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
      format.html { redirect_to users_url }
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
